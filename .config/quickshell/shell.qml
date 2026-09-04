import QtQuick

import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

ShellRoot {
    id: root

    // Rofi Gruvbox Dark palette and geometry.
    readonly property var c: ({
        bg: "#282828", bg1: "#3c3836", bg2: "#504945", bg3: "#665c54", bg4: "#7c6f64",
        fg0: "#fbf1c7", fg1: "#ebdbb2", fg2: "#d5c4a1", fg3: "#bdae93", fg4: "#a89984",
        red: "#cc241d", green: "#98971a", yellow: "#d79921", blue: "#458588",
        purple: "#b16286", aqua: "#689d6a", gray: "#928374", orange: "#d65d0e",
        redBright: "#fb4934", greenBright: "#b8bb26", yellowBright: "#fabd2f",
        blueBright: "#83a598", purpleBright: "#d3869b", aquaBright: "#8ec07c",
        orangeBright: "#fe8019"
    })
    readonly property string fontFamily: "TX-02"
    readonly property int fontSize: 14
    readonly property int padX: 7
    readonly property int padY: 2
    readonly property int borderWidth: 2
    readonly property int itemSpacing: 2
    readonly property int listTopPadding: 20
    readonly property real charWidth: metrics.advanceWidth

    // Hardware and service state.
    readonly property var battery: UPower.devices.values.find(d => d.isLaptopBattery && d.isPresent) || null
    readonly property bool hasBattery: battery !== null
    readonly property var wifi: Networking.devices.values.find(d => d.type === DeviceType.Wifi) || null
    readonly property var wired: Networking.devices.values.find(d => d.type === DeviceType.Wired) || null
    readonly property var bt: Bluetooth.defaultAdapter
    readonly property bool hasBluetooth: bt !== null
    readonly property int btConnected: bt ? bt.devices.values.filter(d => d.connected).length : 0
    readonly property bool networkConnected: Networking.devices.values.some(d => d.connected)
    readonly property var audio: Pipewire.defaultAudioSink
    readonly property var mic: Pipewire.defaultAudioSource

    // One-second system samples.
    property int cpuUsage: 0
    property int memoryUsage: 0
    property real rxRate: 0
    property real txRate: 0
    property real prevCpuTotal: 0
    property real prevCpuIdle: 0
    property real prevRx: 0
    property real prevTx: 0
    property real prevNetTime: 0
    property var prevCores: ({})
    property var cpuCores: []
    property var cpuHistory: []
    property var memoryHistory: []
    property real load1: 0
    property real load5: 0
    property real load15: 0
    property real memoryTotal: 0
    property real memoryAvailable: 0
    property real memoryCached: 0
    property real swapTotal: 0
    property real swapUsed: 0

    // Process views are sampled only while CPU or memory is open.
    property var cpuProcesses: []
    property var memoryProcesses: []

    // Updates.
    property var updatePackages: []
    property string updateState: "checking" // checking | ready | current | upgrading | error
    property string updateError: ""
    property string updateLog: ""
    readonly property int updateCount: updatePackages.length

    // Animation. Mirrors Hyprland's animation config.

    PersistentProperties {
      id: state
      reloadableId: "persistent_state"

      property bool fancy: false
    }

    // Expose animation state through the root so inline components and
    // reusable Behaviors do not accidentally resolve `state` in their own scope.
    readonly property bool animationsEnabled: state.fancy

    readonly property int animDuration: 100
    readonly property real windowEnterScale: 0.94
    readonly property real windowExitScale: 0.97

    readonly property var easeOutQuint: [
        0.23, 1.0,
        0.32, 1.0,
        1.0, 1.0
    ]

    readonly property var easeInOutCubic: [
        0.65, 0.05,
        0.36, 1.0,
        1.0, 1.0
    ]

    readonly property var almostLinear: [
        0.5, 0.5,
        0.75, 1.0,
        1.0, 1.0
    ]

    readonly property var quick: [
        0.15, 0.0,
        0.1, 1.0,
        1.0, 1.0
    ]

    function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)) }
    function push(history, value, limit = 36) {
        const h = history.slice()
        h.push(value)
        while (h.length > limit) h.shift()
        return h
    }
    function formatBytes(kib) {
        if (kib < 1024) return Math.round(kib) + " KiB"
        if (kib < 1048576) return (kib / 1024).toFixed(1) + " MiB"
        return (kib / 1048576).toFixed(1) + " GiB"
    }
    function rate(bytes) {
        const units = ["B", "K", "M", "G", "T"]
        let value = Math.max(0, bytes)
        let unit = 0
        while (value >= 1024 && unit < units.length - 1) {
            value /= 1024
            unit++
        }
        if (unit === 0) return Math.round(value) + "B"
        if (value >= 100) return Math.min(999, Math.round(value)) + units[unit]
        return value.toFixed(1) + units[unit]
    }
    function updateText() {
        if (updateState === "checking") return "new:?"
        if (updateState === "error") return "new:!"
        return updateCount > 999 ? "new:999+" : "new:" + updateCount
    }
    function bluetoothText() {
        if (!bt || !bt.enabled) return "bt:off"
        return btConnected > 99 ? "bt:99+" : "bt:" + btConnected
    }
    function stepWorkspace(delta) {
        const target = delta > 0 ? "e+1" : "e-1"
        if (Hyprland.usingLua) Hyprland.dispatch('hl.dsp.focus({ workspace = "' + target + '" })')
        else Hyprland.dispatch("workspace " + target)
    }
    function deviceName(node) {
        if (!node) return "No audio output"
        return node.description || node.nickname || node.name
    }

    // Audio.
    function setVolume(v) { if (audio && audio.audio) audio.audio.volume = clamp(v, 0, 1) }
    function changeVolume(delta) { if (audio && audio.audio) setVolume(audio.audio.volume + delta) }
    function toggleMute() { if (audio && audio.audio) audio.audio.muted = !audio.audio.muted }
    function setMicVolume(v) { if (mic && mic.audio) mic.audio.volume = clamp(v, 0, 1) }
    function changeMicVolume(delta) { if (mic && mic.audio) setMicVolume(mic.audio.volume + delta) }
    function toggleMicMute() { if (mic && mic.audio) mic.audio.muted = !mic.audio.muted }
    function volumeText() {
        if (!audio || !audio.audio) return "vol:--"
        return audio.audio.muted ? "vol:mute" : "vol:" + Math.round(audio.audio.volume * 100) + "%"
    }

    // Bluetooth.
    readonly property var btDevices: {
        if (!bt) return []
        const a = bt.devices.values.slice()
        a.sort((x, y) => Number(y.connected) - Number(x.connected)
            || Number(y.paired || y.bonded) - Number(x.paired || x.bonded)
            || x.name.localeCompare(y.name))
        return a
    }
    function btAction(d) {
        if (d.pairing) d.cancelPair()
        else if (d.connected) d.disconnect()
        else if (d.paired || d.bonded) d.connect()
        else d.pair()
    }
    function btActionText(d) {
        if (d.pairing) return "cancel"
        if (d.connected) return "disconnect"
        if (d.paired || d.bonded) return "connect"
        return "pair"
    }

    // Network.
    readonly property var wifiNetworks: {
        if (!wifi) return []
        const a = wifi.networks.values.slice()
        a.sort((x, y) => Number(y.connected) - Number(x.connected)
            || Number(y.known) - Number(x.known)
            || y.signalStrength - x.signalStrength)
        return a.slice(0, 10)
    }
    function wifiSecurity(n) {
        switch (n.security) {
        case WifiSecurityType.Open: return "open"
        case WifiSecurityType.WpaPsk: return "wpa"
        case WifiSecurityType.Wpa2Psk: return "wpa2"
        case WifiSecurityType.Sae: return "wpa3"
        case WifiSecurityType.WpaEap:
        case WifiSecurityType.Wpa2Eap: return "enterprise"
        default: return "secured"
        }
    }
    function wifiUsesPsk(n) {
        return n.security === WifiSecurityType.WpaPsk
            || n.security === WifiSecurityType.Wpa2Psk
            || n.security === WifiSecurityType.Sae
    }
    function networkName() {
        for (const d of Networking.devices.values) {
            for (const n of d.networks.values) {
                if (!n.connected) continue
                return d.type === DeviceType.Wifi ? n.name : "ethernet"
            }
        }
        return "disconnected"
    }

    // Battery.
    function batteryState() {
        if (!battery) return "unknown"
        switch (battery.state) {
        case UPowerDeviceState.Charging: return "charging"
        case UPowerDeviceState.Discharging: return "discharging"
        case UPowerDeviceState.FullyCharged: return "full"
        case UPowerDeviceState.Empty: return "empty"
        case UPowerDeviceState.PendingCharge: return "pending charge"
        case UPowerDeviceState.PendingDischarge: return "pending discharge"
        default: return "unknown"
        }
    }
    function batteryTime() {
        if (!battery) return "-"
        const seconds = battery.state === UPowerDeviceState.Charging ? battery.timeToFull : battery.timeToEmpty
        if (seconds <= 0) return "-"
        const h = Math.floor(seconds / 3600)
        const m = Math.floor((seconds % 3600) / 60)
        return h ? h + "h " + m + "m" : m + "m"
    }

    // Calendar.
    function calendarDays(year, month) {
        const first = new Date(year, month, 1)
        const start = new Date(year, month, 1 - ((first.getDay() + 6) % 7))
        return Array.from({length: 42}, (_, i) => {
            const d = new Date(start.getFullYear(), start.getMonth(), start.getDate() + i)
            return { year: d.getFullYear(), month: d.getMonth(), day: d.getDate(),
                current: d.getFullYear() === year && d.getMonth() === month }
        })
    }
    function isToday(d) {
        const t = clock.date
        return d.year === t.getFullYear() && d.month === t.getMonth() && d.day === t.getDate()
    }

    // /proc parsers. FileView avoids a shell process for the always-on metrics.
    function parseStat(text) {
        const next = {}
        const cores = []
        for (const line of text.split("\n")) {
            const p = line.trim().split(/\s+/)
            if (!/^cpu\d*$/.test(p[0] || "")) continue
            const total = p.slice(1).reduce((s, x) => s + Number(x), 0)
            const idle = Number(p[4]) + Number(p[5] || 0)
            if (p[0] === "cpu") {
                if (prevCpuTotal) {
                    const dt = total - prevCpuTotal
                    if (dt > 0) {
                        cpuUsage = Math.round((1 - (idle - prevCpuIdle) / dt) * 100)
                        cpuHistory = push(cpuHistory, cpuUsage)
                    }
                }
                prevCpuTotal = total
                prevCpuIdle = idle
            } else {
                const old = prevCores[p[0]]
                let usage = 0
                if (old) {
                    const dt = total - old.total
                    if (dt > 0) usage = Math.round((1 - (idle - old.idle) / dt) * 100)
                }
                next[p[0]] = {total, idle}
                cores.push({name: p[0], usage: clamp(usage, 0, 100)})
            }
        }
        prevCores = next
        cpuCores = cores
    }
    function parseMem(text) {
        const m = {}
        for (const line of text.split("\n")) {
            const match = line.match(/^(\w+):\s+(\d+)/)
            if (match) m[match[1]] = Number(match[2])
        }
        memoryTotal = m.MemTotal || 0
        memoryAvailable = m.MemAvailable || 0
        memoryCached = (m.Cached || 0) + (m.SReclaimable || 0) - (m.Shmem || 0)
        swapTotal = m.SwapTotal || 0
        swapUsed = Math.max(0, swapTotal - (m.SwapFree || 0))
        if (memoryTotal) {
            memoryUsage = Math.round((memoryTotal - memoryAvailable) / memoryTotal * 100)
            memoryHistory = push(memoryHistory, memoryUsage)
        }
    }
    function parseNet(text) {
        let rx = 0, tx = 0
        for (const line of text.split("\n").slice(2)) {
            const match = line.match(/^\s*([^:]+):\s*(.*)$/)
            if (!match || match[1].trim() === "lo") continue
            const p = match[2].trim().split(/\s+/)
            rx += Number(p[0] || 0)
            tx += Number(p[8] || 0)
        }
        const now = Date.now()
        if (prevNetTime) {
            const seconds = (now - prevNetTime) / 1000
            if (seconds > 0) {
                rxRate = Math.max(0, (rx - prevRx) / seconds)
                txRate = Math.max(0, (tx - prevTx) / seconds)
            }
        }
        prevRx = rx; prevTx = tx; prevNetTime = now
    }
    function parseLoad(text) {
        const p = text.trim().split(/\s+/)
        load1 = Number(p[0] || 0); load5 = Number(p[1] || 0); load15 = Number(p[2] || 0)
    }
    function parseProcesses(text) {
        const all = []
        for (const line of text.trim().split("\n")) {
            const p = line.trim().split(/\s+/)
            if (p.length < 5) continue
            all.push({pid: Number(p[0]), name: p[1], cpu: Number(p[2]), memory: Number(p[3]), rss: Number(p[4])})
        }
        cpuProcesses = all.slice().sort((a, b) => b.cpu - a.cpu).slice(0, 8)
        memoryProcesses = all.slice().sort((a, b) => b.memory - a.memory).slice(0, 8)
    }

    // Updates.
    function parseUpdates(text) {
        if (text.startsWith("__error__")) {
            updateState = "error"
            updateError = text.substring(9).trim()
            updatePackages = []
            return
        }
        const out = []
        for (const line of text.trim().split("\n")) {
            if (!line) continue
            const tab = line.indexOf("\t")
            const m = line.substring(tab + 1).match(/^(\S+)\s+(\S+)\s+->\s+(\S+)$/)
            if (tab < 0 || !m) continue
            out.push({source: line.substring(0, tab), name: m[1], current: m[2], next: m[3]})
        }
        out.sort((a, b) => a.source === b.source ? a.name.localeCompare(b.name) : a.source === "repo" ? -1 : 1)
        updatePackages = out
        updateState = out.length ? "ready" : "current"
        updateError = ""
    }
    function refreshUpdates() {
        if (updateCheck.running || updateUpgrade.running) return
        updateState = "checking"
        updateCheck.running = true
    }
    function beginUpgrade() {
        if (updateCheck.running || updateUpgrade.running) return
        updateLog = ""
        updateError = ""
        updateState = "upgrading"
        updateUpgrade.running = true
    }

    // Power.
    function power(action) {
        root.closePopups()
        switch (action) {
        case "lock":     Quickshell.execDetached(["/usr/bin/hyprlock"]); break
        case "logout":   Quickshell.execDetached(["loginctl", "terminate-session", "auto"]); break
        case "reboot":   Quickshell.execDetached(["reboot"]); break
        case "shutdown": Quickshell.execDetached(["shutdown", "now"]); break
        }
    }

    // IPC is the single keyboard entry point. Open on the focused monitor.
    function focusedBar() {
        for (const b of bars.instances) if (b.hyprMonitor && b.hyprMonitor.focused) return b
        return bars.instances.length ? bars.instances[0] : null
    }
    function closePopups() {
        for (const b of bars.instances) b.closePopups()
        notificationCenterOpen = false
    }
    function detailsOpen() {
        for (const b of bars.instances) if (b.cpuOpen || b.memoryOpen) return true
        return false
    }
    function togglePopup(bar, name) {
        if (!bar || !bar.allowed(name)) return
        const p = bar.popup(name)
        if (!p) return
        const show = !p.requestedVisible
        closePopups()
        if (show) bar.openPopup(name)
    }
    function toggleFocused(name) { togglePopup(focusedBar(), name) }
    function notify(app, summary, body = "", urgency = "normal") {
      Quickshell.execDetached([
        "notify-send",
        "-a", app,
        "-u", urgency,
        summary,
        body
      ])
    }

    IpcHandler {
        target: "bar"
        function toggle(name: string): void { root.toggleFocused(name) }
        function close(): void { root.closePopups() }
        function volume(deltaPercent: int): void { root.changeVolume(deltaPercent / 100) }
        function mute(): void { root.toggleMute() }
        function micVolume(deltaPercent: int): void { root.changeMicVolume(deltaPercent / 100) }
        function micMute(): void { root.toggleMicMute() }

        function dismiss(): void { root.dismissLatestNotification() }
        function dismissAll(): void { root.dismissAllNotifications() }
        function toggleDnd(): bool { return root.toggleNotificationDnd() }
        function getDnd(): bool { return root.notificationDnd }
        function toggleCenter(): bool { return root.toggleNotificationCenter() }
        function closeCenter(): void { root.notificationCenterOpen = false }
        function clearHistory(): void { root.clearNotificationHistory() }

        function setAnimations(value: bool): bool { state.fancy = value; return state.fancy; }
        function getAnimations(): bool { return state.fancy; }
        function toggleAnimations(): bool { state.fancy = !state.fancy; return state.fancy; }
        function enableAnimations(): void { state.fancy = true }
        function disableAnimations(): void { state.fancy = false }
    }

    TextMetrics {
        id: metrics
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        text: "0"
    }
    SystemClock { id: clock; precision: SystemClock.Minutes }
    PwObjectTracker { objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource] }

    // Native file reads for system metrics.
    FileView { id: statFile; path: "/proc/stat"; onLoaded: root.parseStat(text()) }
    FileView { id: memFile; path: "/proc/meminfo"; onLoaded: root.parseMem(text()) }
    FileView { id: netFile; path: "/proc/net/dev"; onLoaded: root.parseNet(text()) }
    FileView { id: loadFile; path: "/proc/loadavg"; onLoaded: root.parseLoad(text()) }

    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            statFile.reload(); memFile.reload(); netFile.reload(); loadFile.reload()
            if (root.detailsOpen() && !processList.running) processList.running = true
        }
    }

    Process {
        id: processList
        command: ["/usr/bin/ps", "-eo", "pid=,comm=,%cpu=,%mem=,rss="]
        stdout: StdioCollector { onStreamFinished: root.parseProcesses(text) }
    }

    Process {
        id: updateCheck
        command: ["/bin/sh", "-c",
            "if [ ! -x /usr/bin/checkupdates ] || [ ! -x /usr/bin/yay ]; then " +
            "echo '__error__ missing checkupdates or yay'; exit 0; fi; " +
            "{ /usr/bin/checkupdates --nocolor 2>/dev/null | awk '{print \"repo\\t\" $0}'; " +
            "/usr/bin/yay -Qua --color never 2>/dev/null | awk '{print \"aur\\t\" $0}'; }"]
        stdout: StdioCollector { id: updateOutput }
        onExited: root.parseUpdates(updateOutput.text)
    }

    Process {
        id: updateUpgrade
        command: ["/usr/bin/yay", "-Syu", "--sudo", "/usr/bin/sudo", "--sudoflags", "-n", "--noconfirm"]
        stdout: SplitParser { onRead: line => root.updateLog += line + "\n" }
        stderr: SplitParser { onRead: line => root.updateLog += line + "\n" }
        onExited: code => {
            if (code === 0) {
                root.updatePackages = []
                root.updateState = "current"
                root.refreshUpdates()
            } else {
                root.updateState = "error"
                root.updateError = "yay exited with code " + code
            }
        }
    }

    Timer {
        interval: 300000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: root.refreshUpdates()
    }

    Variants {
        id: bars
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            readonly property var hyprMonitor: Hyprland.monitorFor(screen)
            readonly property bool cpuOpen: cpuPopup.visible
            readonly property bool memoryOpen: memoryPopup.visible

            screen: modelData
            aboveWindows: true
            color: root.c.bg
            implicitHeight: Math.max(left.implicitHeight, center.implicitHeight, right.implicitHeight)
            exclusiveZone: implicitHeight
            anchors { top: true; left: true; right: true }

            function popup(name) {
                switch (name) {
                case "calendar": return calendarPopup
                case "bluetooth": return bluetoothPopup
                case "updates": return updatePopup
                case "network": return networkPopup
                case "volume": return volumePopup
                case "cpu": return cpuPopup
                case "memory": return memoryPopup
                case "battery": return batteryPopup
                case "power": return powerPopup
                default: return null
                }
            }
            function allowed(name) {
                return (name !== "bluetooth" || root.hasBluetooth)
                    && (name !== "battery" || root.hasBattery)
            }
            function closePopups() {
                for (const name of ["calendar","bluetooth","updates","network","volume","cpu","memory","battery","power"]) {
                    const p = popup(name)
                    if (p) p.hideAnimated()
                }
            }
            function openPopup(name) {
                const p = popup(name)
                if (!p) return
                p.showAnimated()
                if (name === "updates" && root.updateState === "checking" && !updateCheck.running) root.refreshUpdates()
                if ((name === "cpu" || name === "memory") && !processList.running) processList.running = true
            }
            function togglePopup(name) { root.togglePopup(panel, name) }

            Row {
                id: left
                spacing: root.itemSpacing
                anchors { left: parent.left; top: parent.top }

                Repeater {
                    model: 9
                    BarModule {
                        required property int index
                        readonly property int workspaceId: index + 1
                        readonly property var workspace: Hyprland.workspaces.values.find(w => w.id === workspaceId) || null
                        readonly property bool active: panel.hyprMonitor && panel.hyprMonitor.activeWorkspace && panel.hyprMonitor.activeWorkspace.id === workspaceId
                        fixedCharacters: 1
                        text: String(workspaceId)
                        bold: active
                        normalBackground: active ? root.c.orangeBright : workspace && workspace.urgent ? root.c.redBright : root.c.bg
                        normalForeground: root.c.fg1
                        onActivated: {
                            if (workspace) workspace.activate()
                            else if (Hyprland.usingLua) Hyprland.dispatch('hl.dsp.focus({ workspace = "' + workspaceId + '" })')
                            else Hyprland.dispatch("workspace " + workspaceId)
                        }
                        onWheelUp: root.stepWorkspace(-1)
                        onWheelDown: root.stepWorkspace(1)
                    }
                }
            }

            // Keep the clock exactly screen-centered. The invisible right spacer
            // mirrors the updates module on the left.
            Row {
                id: center
                spacing: root.itemSpacing
                anchors { horizontalCenter: parent.horizontalCenter; top: parent.top }

                BarModule {
                    id: updateModule
                    fixedCharacters: 8
                    text: root.updateText()
                    normalForeground: root.updateState === "error" ? root.c.redBright
                        : root.updateCount ? root.c.orangeBright : root.c.fg1
                    onActivated: panel.togglePopup("updates")
                }
                BarModule {
                    id: clockModule
                    fixedCharacters: 16
                    text: Qt.formatDateTime(clock.date, "yyyy-MM-dd HH:mm")
                    onActivated: panel.togglePopup("calendar")
                }
                Item {
                    width: root.charWidth * 8 + root.padX * 2
                    height: 1
                }
            }

            Row {
                id: right
                spacing: root.itemSpacing
                anchors { right: parent.right; top: parent.top }

                BarModule {
                    id: bluetoothModule
                    visible: root.hasBluetooth
                    fixedCharacters: 6
                    text: root.bluetoothText()
                    normalForeground: (!root.bt || !root.bt.enabled) ? root.c.fg4
                        : root.btConnected ? root.c.greenBright : root.c.fg1
                    onActivated: panel.togglePopup("bluetooth")
                }
                BarModule {
                    id: networkModule
                    fixedCharacters: 17
                    text: root.networkConnected ? "rx:" + root.rate(root.rxRate) + " tx:" + root.rate(root.txRate) : "net:off"
                    normalForeground: root.networkConnected ? root.c.fg1 : root.c.redBright
                    onActivated: panel.togglePopup("network")
                }
                BarModule {
                    id: volumeModule
                    fixedCharacters: 8
                    text: root.volumeText()
                    normalForeground: root.audio && root.audio.audio && root.audio.audio.muted ? root.c.yellowBright : root.c.fg1
                    onActivated: panel.togglePopup("volume")
                    onWheelUp: root.changeVolume(0.05)
                    onWheelDown: root.changeVolume(-0.05)
                }
                BarModule {
                    id: cpuModule
                    fixedCharacters: 8
                    text: "cpu:" + root.cpuUsage + "%"
                    normalForeground: root.cpuUsage >= 90 ? root.c.redBright : root.cpuUsage >= 70 ? root.c.yellowBright : root.c.fg1
                    onActivated: panel.togglePopup("cpu")
                }
                BarModule {
                    id: memoryModule
                    fixedCharacters: 8
                    text: "mem:" + root.memoryUsage + "%"
                    normalForeground: root.memoryUsage >= 90 ? root.c.redBright : root.memoryUsage >= 75 ? root.c.yellowBright : root.c.fg1
                    onActivated: panel.togglePopup("memory")
                }
                BarModule {
                    id: batteryModule
                    visible: root.hasBattery
                    fixedCharacters: 8
                    readonly property int pct: root.battery ? Math.round(root.battery.percentage * 100) : 0
                    readonly property bool plugged: !UPower.onBattery
                    text: "bat:" + pct + "%"
                    normalBackground: plugged ? root.c.green : pct <= 15 ? root.c.redBright : pct <= 30 ? root.c.yellow : root.c.bg
                    normalForeground: !plugged && pct <= 30 ? root.c.bg : root.c.fg1
                    lockHoverBackground: plugged || pct <= 30
                    lockHoverForeground: !plugged && pct <= 30
                    onActivated: panel.togglePopup("battery")
                }
                BarModule {
                    id: notificationModule
                    fixedCharacters: 8
                    text: root.notificationDnd
                        ? "ntf:dnd"
                        : "ntf:" + Math.min(99, root.notificationHistory.length)
                    normalForeground: root.notificationDnd ? root.c.yellowBright
                        : root.notificationHistory.length ? root.c.orangeBright : root.c.fg1
                    onActivated: root.toggleNotificationCenter()
                }
                BarModule {
                    id: powerModule
                    fixedCharacters: 3
                    text: "pwr"
                    hoverBackground: root.c.redBright
                    onActivated: panel.togglePopup("power")
                }
            }

            MenuPopup {
                id: volumePopup
                owner: panel
                anchorItem: volumeModule
                popupWidth: 420
                onKeyPressed: event => {
                    const shift = event.modifiers & Qt.ShiftModifier
                    if (event.key === Qt.Key_M) { root.toggleMute(); event.accepted = true }
                    else if (event.key === Qt.Key_I) { root.toggleMicMute(); event.accepted = true }
                    else if (shift && (event.key === Qt.Key_Plus || event.key === Qt.Key_Equal)) { root.changeMicVolume(0.05); event.accepted = true }
                    else if (shift && event.key === Qt.Key_Minus) { root.changeMicVolume(-0.05); event.accepted = true }
                    else if (event.key === Qt.Key_Plus || event.key === Qt.Key_Equal) { root.changeVolume(0.05); event.accepted = true }
                    else if (event.key === Qt.Key_Minus) { root.changeVolume(-0.05); event.accepted = true }
                }

                Header {
                    title: "output"
                    titleColor: root.c.orangeBright
                    subtitle: root.deviceName(root.audio)
                    actionText: root.audio && root.audio.audio && root.audio.audio.muted ? "unmute" : "mute"
                    actionSelected: root.audio && root.audio.audio ? root.audio.audio.muted : false
                    actionAccent: root.c.orangeBright
                    onAction: root.toggleMute()
                }
                VolumeSlider {
                    width: parent.width
                    value: root.audio && root.audio.audio ? root.audio.audio.volume : 0
                    fillColor: root.c.orangeBright
                    onChanged: value => root.setVolume(value)
                }
                Section { text: "output devices"; accent: root.c.orangeBright }
                Repeater {
                    model: ScriptModel { values: Pipewire.nodes.values.filter(n => n.audio && n.isSink && !n.isStream) }
                    ActionRow {
                        required property var modelData
                        required property int index
                        text: root.deviceName(modelData)
                        selected: modelData === Pipewire.defaultAudioSink
                        alternate: index % 2 === 1
                        accent: root.c.orangeBright
                        onActivated: Pipewire.preferredDefaultAudioSink = modelData
                    }
                }

                Section { text: "input"; accent: root.c.aquaBright }
                Header {
                    title: "microphone"
                    titleColor: root.c.aquaBright
                    subtitle: root.deviceName(root.mic)
                    actionText: root.mic && root.mic.audio && root.mic.audio.muted ? "unmute" : "mute"
                    actionSelected: root.mic && root.mic.audio ? root.mic.audio.muted : false
                    actionAccent: root.c.aqua
                    onAction: root.toggleMicMute()
                }
                VolumeSlider {
                    width: parent.width
                    value: root.mic && root.mic.audio ? root.mic.audio.volume : 0
                    fillColor: root.c.aqua
                    onChanged: value => root.setMicVolume(value)
                }
                Section { text: "input devices"; accent: root.c.aquaBright }
                Repeater {
                    model: ScriptModel { values: Pipewire.nodes.values.filter(n => n.audio && !n.isSink && !n.isStream) }
                    ActionRow {
                        required property var modelData
                        required property int index
                        text: root.deviceName(modelData)
                        selected: modelData === Pipewire.defaultAudioSource
                        alternate: index % 2 === 1
                        accent: root.c.aqua
                        onActivated: Pipewire.preferredDefaultAudioSource = modelData
                    }
                }
            }

            MenuPopup {
                id: networkPopup
                owner: panel
                anchorItem: networkModule
                popupWidth: 390
                property var pending: null
                property string status: ""

                Connections {
                    target: networkPopup
                    function onVisibleChanged() {
                        if (root.wifi) root.wifi.scannerEnabled = networkPopup.visible
                        if (!networkPopup.visible) {
                            networkPopup.pending = null
                            networkPopup.status = ""
                            wifiPassword.text = ""
                        }
                    }
                }
                onKeyPressed: event => {
                    if (event.key === Qt.Key_W && root.wifi) {
                        Networking.wifiEnabled = !Networking.wifiEnabled
                        event.accepted = true
                    }
                }

                function connectNetwork(n) {
                    status = ""
                    if (n.stateChanging) return
                    if (n.connected) { n.disconnect(); return }
                    if (n.known || n.security === WifiSecurityType.Open) {
                        n.connect(); status = "connecting to " + n.name; return
                    }
                    if (root.wifiUsesPsk(n)) {
                        pending = n
                        Qt.callLater(() => wifiPassword.forceActiveFocus())
                        return
                    }
                    status = n.name + ": saved NetworkManager profile required"
                }
                function connectPending() {
                    if (!pending || !wifiPassword.text) return
                    status = "connecting to " + pending.name
                    pending.connectWithPsk(wifiPassword.text)
                    pending = null
                    wifiPassword.text = ""
                }

                Header {
                    title: "network"
                    subtitle: root.networkName()
                    actionText: root.wifi ? (Networking.wifiEnabled ? "wifi:on" : "wifi:off") : ""
                    actionVisible: root.wifi !== null
                    actionSelected: Networking.wifiEnabled
                    onAction: Networking.wifiEnabled = !Networking.wifiEnabled
                }
                ValueRow {
                    visible: root.wired !== null
                    label: "ethernet"
                    value: root.wired && root.wired.connected
                        ? "connected" + (root.wired.linkSpeed > 0 ? " " + root.wired.linkSpeed + " Mbps" : "")
                        : "disconnected"
                }
                Section { visible: root.wifi !== null && Networking.wifiEnabled; text: "wifi" }
                Repeater {
                    model: ScriptModel { values: root.wifi && Networking.wifiEnabled ? root.wifiNetworks : [] }
                    ActionRow {
                        required property var modelData
                        required property int index
                        text: modelData.name + (modelData.stateChanging ? " ..." : "")
                        alternate: index % 2 === 1
                        detail: root.wifiSecurity(modelData) + " " + Math.round(modelData.signalStrength * 100) + "%"
                        selected: modelData.connected
                        onActivated: networkPopup.connectNetwork(modelData)
                        Connections {
                            target: modelData
                            function onConnectionFailed(reason) {
                                networkPopup.status = "failed to connect to " + modelData.name
                            }
                        }
                    }
                }
                UiText {
                    visible: root.wifi && Networking.wifiEnabled && root.wifiNetworks.length === 0
                    text: "scanning..."
                    tone: "muted"
                }
                Column {
                    visible: networkPopup.pending !== null
                    width: parent.width
                    spacing: 6
                    Divider { implicitWidth: parent.width }
                    UiText { text: networkPopup.pending ? "password: " + networkPopup.pending.name : ""; tone: "muted" }
                    Row {
                        width: parent.width
                        spacing: 8
                        Rectangle {
                            implicitWidth: parent.width - connectWifi.width - parent.spacing
                            implicitHeight: wifiPassword.implicitHeight + 10
                            color: root.c.bg1
                            TextInput {
                                id: wifiPassword
                                anchors { fill: parent; leftMargin: 7; rightMargin: 7 }
                                verticalAlignment: TextInput.AlignVCenter
                                echoMode: TextInput.Password
                                color: root.c.fg1
                                selectionColor: root.c.orangeBright
                                selectedTextColor: root.c.fg1
                                font.family: root.fontFamily
                                font.pixelSize: root.fontSize
                                clip: true
                                Keys.onReturnPressed: networkPopup.connectPending()
                                Keys.onEscapePressed: {
                                    networkPopup.pending = null
                                    text = ""
                                }
                            }
                        }
                        Button { id: connectWifi; text: "connect"; onActivated: networkPopup.connectPending() }
                    }
                }
                UiText { visible: networkPopup.status !== ""; text: networkPopup.status; color: root.c.yellow; wrapMode: Text.Wrap }
            }

            MenuPopup {
                id: bluetoothPopup
                owner: panel
                anchorItem: bluetoothModule
                popupWidth: 390
                onKeyPressed: event => {
                    if (!root.bt) return
                    if (event.key === Qt.Key_B) { root.bt.enabled = !root.bt.enabled; event.accepted = true }
                    else if (event.key === Qt.Key_S && root.bt.enabled) {
                        root.bt.discovering = !root.bt.discovering; event.accepted = true
                    }
                }

                Header {
                    title: "bluetooth"
                    subtitle: root.bt ? root.bt.name : ""
                    actionText: root.bt && root.bt.enabled ? "bt:on" : "bt:off"
                    actionSelected: root.bt ? root.bt.enabled : false
                    onAction: if (root.bt) root.bt.enabled = !root.bt.enabled
                }
                Row {
                    visible: root.bt ? root.bt.enabled : false
                    width: parent.width
                    spacing: 8
                    Button {
                        text: root.bt && root.bt.discovering ? "scanning..." : "scan"
                        selected: root.bt ? root.bt.discovering : false
                        onActivated: root.bt.discovering = !root.bt.discovering
                    }
                    Button {
                        text: root.bt && root.bt.discoverable ? "discoverable" : "hidden"
                        selected: root.bt ? root.bt.discoverable : false
                        onActivated: root.bt.discoverable = !root.bt.discoverable
                    }
                }
                UiText { visible: root.bt && !root.bt.enabled; text: "bluetooth is disabled"; tone: "muted" }
                Section { visible: root.bt ? root.bt.enabled : false; text: "devices" }
                Repeater {
                    model: ScriptModel { values: root.bt && root.bt.enabled ? root.btDevices : [] }
                    ActionRow {
                        required property var modelData
                        required property int index
                        text: modelData.name
                        detail: (modelData.batteryAvailable ? "bat:" + Math.round(modelData.battery * 100) + "% " : "")
                            + root.btActionText(modelData)
                        alternate: index % 2 === 1
                        selected: modelData.connected
                        onActivated: root.btAction(modelData)
                    }
                }
                UiText {
                    visible: root.bt && root.bt.enabled && root.btDevices.length === 0
                    text: root.bt && root.bt.discovering ? "scanning..." : "no devices"
                    tone: "muted"
                }
            }

            MenuPopup {
                id: updatePopup
                owner: panel
                anchorItem: updateModule
                popupEdges: Edges.Bottom
                popupGravity: Edges.Bottom
                popupWidth: 460
                property bool confirm: false

                Connections {
                    target: updatePopup
                    function onVisibleChanged() { if (!updatePopup.visible) updatePopup.confirm = false }
                }
                onKeyPressed: event => {
                    if (event.key === Qt.Key_R && !updateCheck.running && !updateUpgrade.running) {
                        root.refreshUpdates(); event.accepted = true
                    } else if (event.key === Qt.Key_U && root.updateState === "ready") {
                        updatePopup.confirm = true; event.accepted = true
                    }
                }

                Header {
                    title: "updates"
                    subtitle: root.updateState === "checking" ? "checking..."
                        : root.updateState === "current" ? "system is up to date"
                        : root.updateState === "upgrading" ? "upgrading..."
                        : root.updateState === "error" ? "error"
                        : root.updateCount + (root.updateCount === 1 ? " package" : " packages")
                    actionText: updateCheck.running ? "checking..." : "refresh"
                    actionEnabled: !updateCheck.running && !updateUpgrade.running
                    onAction: root.refreshUpdates()
                }

                UiText { visible: root.updateState === "current"; text: "nothing to do"; color: root.c.green }
                UiText { visible: root.updateState === "error"; text: root.updateError; color: root.c.redBright; wrapMode: Text.Wrap }

                Rectangle {
                    visible: root.updatePackages.length > 0 && root.updateState !== "upgrading"
                    implicitWidth: parent.width
                    implicitHeight: Math.min(packageColumn.implicitHeight, 280)
                    color: root.c.bg
                    border.width: root.borderWidth
                    border.color: root.c.bg2
                    clip: true

                    Flickable {
                        anchors.fill: parent
                        contentWidth: width
                        contentHeight: packageColumn.implicitHeight
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true
                        Column {
                            id: packageColumn
                            width: parent.width
                            spacing: root.itemSpacing
                            Repeater {
                                model: ScriptModel { values: root.updatePackages }
                                Rectangle {
                                    required property var modelData
                                    required property int index
                                    implicitWidth: packageColumn.width
                                    implicitHeight: packageRow.implicitHeight + 10
                                    color: index % 2 ? root.c.bg1 : root.c.bg
                                    Row {
                                        id: packageRow
                                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 7; rightMargin: 7 }
                                        spacing: 8
                                        UiText { width: parent.width * 0.44; text: modelData.name; bold: true; elide: Text.ElideRight }
                                        UiText {
                                            width: root.charWidth * 5
                                            text: modelData.source
                                            color: modelData.source === "aur" ? root.c.orangeBright : root.c.aquaBright
                                            bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                        UiText {
                                            width: parent.width - parent.width * 0.44 - root.charWidth * 5 - parent.spacing * 2
                                            text: modelData.current + " -> " + modelData.next
                                            tone: "muted"
                                            elide: Text.ElideRight
                                            horizontalAlignment: Text.AlignRight
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Row {
                    visible: root.updateState === "ready"
                    width: parent.width
                    spacing: root.itemSpacing
                    Button {
                        visible: !updatePopup.confirm
                        text: "upgrade " + root.updateCount
                        onActivated: updatePopup.confirm = true
                    }
                    Button {
                        visible: updatePopup.confirm
                        text: "confirm upgrade"
                        danger: true
                        onActivated: {
                            updatePopup.confirm = false
                            root.beginUpgrade()
                        }
                    }
                    Button {
                        visible: updatePopup.confirm
                        text: "cancel"
                        onActivated: updatePopup.confirm = false
                    }
                }

                Column {
                    visible: root.updateState === "upgrading"
                    width: parent.width
                    spacing: root.itemSpacing
                    Section { text: "yay"; accent: root.c.orangeBright }
                    Rectangle {
                        implicitWidth: parent.width
                        implicitHeight: 220
                        color: root.c.bg
                        border.width: root.borderWidth
                        border.color: root.c.bg2
                        Flickable {
                            id: updateLogView
                            anchors { fill: parent; margins: 7 }
                            contentWidth: width
                            contentHeight: updateLogText.implicitHeight
                            boundsBehavior: Flickable.StopAtBounds
                            clip: true
                            UiText {
                                id: updateLogText
                                width: updateLogView.width
                                text: root.updateLog || "starting..."
                                color: root.c.fg2
                                wrapMode: Text.WrapAnywhere
                            }
                            onContentHeightChanged: contentY = Math.max(0, contentHeight - height)
                        }
                    }
                }
            }

            MenuPopup {
                id: cpuPopup
                owner: panel
                anchorItem: cpuModule
                popupWidth: 560

                Header { title: "cpu"; subtitle: root.cpuUsage + "%" }
                HistoryGraph { width: parent.width; values: root.cpuHistory; warn: 70; critical: 90 }
                ValueRow {
                    label: "load"
                    value: "1m " + root.load1.toFixed(2) + "   5m " + root.load5.toFixed(2) + "   15m " + root.load15.toFixed(2)
                }
                Section { text: "cores"; accent: root.c.orangeBright }
                Grid {
                    id: coreGrid
                    width: parent.width
                    columns: 2
                    columnSpacing: 20
                    rowSpacing: 8
                    Repeater {
                        model: ScriptModel { values: root.cpuCores }
                        MeterRow {
                            required property var modelData
                            width: (coreGrid.width - coreGrid.columnSpacing) / 2
                            label: modelData.name
                            value: modelData.usage
                        }
                    }
                }
                Section { text: "processes"; accent: root.c.orangeBright }
                ProcessTable { width: parent.width; values: root.cpuProcesses }
            }

            MenuPopup {
                id: memoryPopup
                owner: panel
                anchorItem: memoryModule
                popupWidth: 560

                Header { title: "memory"; subtitle: root.memoryUsage + "%" }
                HistoryGraph { width: parent.width; values: root.memoryHistory; warn: 75; critical: 90 }
                Section { text: "ram"; accent: root.c.orangeBright }
                ValueRow {
                    label: "used"
                    value: root.formatBytes(root.memoryTotal - root.memoryAvailable) + " / " + root.formatBytes(root.memoryTotal)
                }
                Meter { width: parent.width; value: root.memoryUsage / 100; warn: root.memoryUsage >= 75; critical: root.memoryUsage >= 90 }
                ValueRow { label: "available"; value: root.formatBytes(root.memoryAvailable) }
                ValueRow { label: "cache"; value: root.formatBytes(root.memoryCached) }
                Section { text: "swap"; accent: root.c.aquaBright }
                ValueRow {
                    label: root.swapTotal ? "used" : "state"
                    value: root.swapTotal ? root.formatBytes(root.swapUsed) + " / " + root.formatBytes(root.swapTotal) : "disabled"
                }
                Meter {
                    visible: root.swapTotal > 0
                    width: parent.width
                    value: root.swapTotal ? root.swapUsed / root.swapTotal : 0
                    fillColor: root.c.aqua
                }
                Section { text: "processes"; accent: root.c.orangeBright }
                ProcessTable { width: parent.width; values: root.memoryProcesses }
            }

            MenuPopup {
                id: batteryPopup
                owner: panel
                anchorItem: batteryModule
                popupWidth: 390

                Header { title: "battery"; subtitle: root.battery ? Math.round(root.battery.percentage * 100) + "%" : "-" }
                Meter {
                    implicitWidth: parent.width
                    value: root.battery ? root.battery.percentage : 0
                    fillColor: !UPower.onBattery ? root.c.green : (root.battery && root.battery.percentage <= 0.15) ? root.c.red
                        : (root.battery && root.battery.percentage <= 0.3) ? root.c.yellow : root.c.orangeBright
                }
                ValueRow { label: "state"; value: root.batteryState() }
                ValueRow { label: root.battery && root.battery.state === UPowerDeviceState.Charging ? "until full" : "remaining"; value: root.batteryTime() }
                ValueRow { label: UPower.onBattery ? "power draw" : "charge rate"; value: root.battery ? Math.abs(root.battery.changeRate).toFixed(1) + " W" : "-" }
                ValueRow { label: "energy"; value: root.battery ? root.battery.energy.toFixed(1) + " / " + root.battery.energyCapacity.toFixed(1) + " Wh" : "-" }
                Section { visible: root.battery ? root.battery.healthSupported : false; text: "health" }
                ValueRow { visible: root.battery ? root.battery.healthSupported : false; label: "capacity"; value: root.battery ? Math.round(root.battery.healthPercentage) + "%" : "-" }
                Meter { visible: root.battery ? root.battery.healthSupported : false; implicitWidth: parent.width; value: root.battery ? root.battery.healthPercentage / 100 : 0; fillColor: root.c.green }
                Divider { implicitWidth: parent.width }
                ValueRow { visible: (root.battery ? root.battery.model : "") !== ""; label: "model"; value: root.battery ? root.battery.model : "" }
                ValueRow { label: "device"; value: root.battery ? root.battery.nativePath : "" }
            }

            MenuPopup {
                id: powerPopup
                owner: panel
                anchorItem: powerModule
                popupWidth: 300
                property string pending: ""

                onKeyPressed: event => {
                    if (pending !== "") return
                    if (event.key === Qt.Key_L) { root.power("lock"); event.accepted = true }
                    else if (event.key === Qt.Key_O) { pending = "logout"; event.accepted = true }
                    else if (event.key === Qt.Key_R) { pending = "reboot"; event.accepted = true }
                    else if (event.key === Qt.Key_P) { pending = "shutdown"; event.accepted = true }
                }

                Connections {
                    target: powerPopup
                    function onVisibleChanged() { if (!powerPopup.visible) powerPopup.pending = "" }
                }

                Header { title: "power" }
                Repeater {
                    model: powerPopup.pending ? [] : [
                        {name: "lock", label: "lock", key: "L"},
                        {name: "logout", label: "log out", key: "O"},
                        {name: "reboot", label: "reboot", key: "R"},
                        {name: "shutdown", label: "shut down", key: "P"}
                    ]
                    ActionRow {
                        required property var modelData
                        required property int index
                        text: modelData.label
                        detail: modelData.key
                        alternate: index % 2 === 1
                        danger: modelData.name === "shutdown"
                        onActivated: {
                            if (modelData.name === "lock") root.power(modelData.name)
                            else powerPopup.pending = modelData.name
                        }
                    }
                }
                Column {
                    visible: powerPopup.pending !== ""
                    width: parent.width
                    spacing: root.itemSpacing
                    Section { text: "confirm"; accent: root.c.yellowBright }
                    UiText {
                        width: parent.width
                        text: (powerPopup.pending === "logout" ? "log out" : powerPopup.pending === "shutdown" ? "shut down" : powerPopup.pending) + "?"
                        bold: true
                    }
                    Row {
                        width: parent.width
                        spacing: root.itemSpacing
                        Button {
                            width: (parent.width - parent.spacing) / 2
                            text: "confirm"
                            danger: true
                            onActivated: root.power(powerPopup.pending)
                        }
                        Button {
                            width: (parent.width - parent.spacing) / 2
                            text: "cancel"
                            onActivated: powerPopup.pending = ""
                        }
                    }
                }
            }

            MenuPopup {
                id: calendarPopup
                owner: panel
                anchorItem: clockModule
                popupWidth: 360
                popupEdges: Edges.Bottom
                popupGravity: Edges.Bottom
                property int year: clock.date.getFullYear()
                property int month: clock.date.getMonth()
                readonly property var days: root.calendarDays(year, month)

                function step(delta) {
                    const d = new Date(year, month + delta, 1)
                    year = d.getFullYear(); month = d.getMonth()
                }
                function today() { year = clock.date.getFullYear(); month = clock.date.getMonth() }

                Connections {
                    target: calendarPopup
                    function onVisibleChanged() { if (calendarPopup.visible) calendarPopup.today() }
                }
                onKeyPressed: event => {
                    if (event.key === Qt.Key_Left) { step(-1); event.accepted = true }
                    else if (event.key === Qt.Key_Right) { step(1); event.accepted = true }
                    else if (event.key === Qt.Key_T) { today(); event.accepted = true }
                }

                Header {
                    title: Qt.formatDateTime(clock.date, "dddd")
                    subtitle: Qt.formatDateTime(clock.date, "dd MMMM yyyy")
                    actionText: Qt.formatDateTime(clock.date, "HH:mm")
                    actionEnabled: false
                }
                Row {
                    width: parent.width
                    spacing: 8
                    Button { implicitWidth: 30; text: "<"; onActivated: calendarPopup.step(-1) }
                    UiText {
                        width: parent.width - 2 * 30 - todayButton.width - parent.spacing * 3
                        text: Qt.formatDateTime(new Date(calendarPopup.year, calendarPopup.month, 1), "MMMM yyyy")
                        bold: true
                        horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Button { id: todayButton; text: "today"; onActivated: calendarPopup.today() }
                    Button { implicitWidth: 30; text: ">"; onActivated: calendarPopup.step(1) }
                }
                Grid {
                    width: parent.width
                    columns: 7
                    Repeater {
                        model: ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
                        UiText {
                            required property string modelData
                            width: parent.width / 7
                            text: modelData
                            tone: "quiet"
                            bold: true
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
                Grid {
                    id: calendarGrid
                    width: parent.width
                    columns: 7
                    rowSpacing: 2
                    columnSpacing: 2
                    Repeater {
                        model: ScriptModel { values: calendarPopup.days }
                        Button {
                            required property var modelData
                            implicitWidth: (calendarGrid.width - calendarGrid.columnSpacing * 6) / 7
                            implicitHeight: 32
                            text: String(modelData.day)
                            tabStop: false
                            selected: root.isToday(modelData)
                            foreground: !modelData.current && !selected ? root.c.bg4 : root.c.fg1
                            onActivated: {
                                if (!modelData.current) {
                                    calendarPopup.year = modelData.year
                                    calendarPopup.month = modelData.month
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Keyboard contract: Esc closes; Tab/Shift+Tab move focus; Enter/Space activate.
    // Volume: M mute, +/- adjust. Network: W wifi. Bluetooth: B power, S scan.
    // Updates: R refresh, U arm upgrade. Power: L lock, O logout, R reboot, P shutdown.
    // Calendar: Left/Right month, T today. Workspaces: mouse wheel changes workspace.
    // --- Semantic UI primitives -------------------------------------------------

    component UiText: Text {
        property string tone: "normal" // normal | muted | quiet
        property bool bold: false
        color: tone === "muted" ? root.c.fg3 : tone === "quiet" ? root.c.fg4 : root.c.fg1
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        font.weight: bold ? 900 : 400
        verticalAlignment: Text.AlignVCenter
    }

    component Divider: Rectangle {
        implicitHeight: root.borderWidth
        color: root.c.bg2
    }

    // Matches the Rofi listview: 20px top padding, 2px separator, 2px spacing.
    component Section: Column {
        id: section
        required property string text
        property color accent: root.c.fg3
        width: parent ? parent.width : implicitWidth
        spacing: root.itemSpacing
        Item { width: parent.width; height: root.listTopPadding }
        Divider { width: parent.width }
        UiText { text: section.text; color: section.accent; bold: true }
    }

    component Button: Rectangle {
        id: button
        required property string text
        property bool selected: false
        property bool danger: false
        property bool tabStop: true
        property color foreground: danger ? root.c.redBright : root.c.fg1
        property color accent: root.c.orangeBright
        signal activated()

        implicitWidth: label.implicitWidth + 14
        implicitHeight: label.implicitHeight + 8
        readonly property bool highlighted: selected || hover.containsMouse || activeFocus
        color: danger && highlighted ? root.c.redBright
            : highlighted ? accent : root.c.bg
        opacity: enabled ? 1 : 0.5
        activeFocusOnTab: enabled && tabStop

        StateAnim on color {}

        UiText {
            id: label
            anchors.centerIn: parent
            text: button.text
            color: button.danger && button.highlighted ? root.c.bg
                : button.highlighted ? root.c.bg1 : button.foreground
            bold: button.highlighted
        }
        MouseArea {
            id: hover
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            enabled: button.enabled
            onClicked: { button.forceActiveFocus(); button.activated() }
        }
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                button.activated()
                event.accepted = true
            }
        }
    }

    component ActionRow: Rectangle {
        id: row
        required property string text
        property string detail: ""
        property bool selected: false
        property bool danger: false
        property bool alternate: false
        property color accent: root.c.orangeBright
        signal activated()

        width: parent ? parent.width : implicitWidth
        implicitHeight: Math.max(name.implicitHeight, detailText.implicitHeight) + 12
        readonly property bool highlighted: selected || mouse.containsMouse || activeFocus
        readonly property color baseBackground: alternate ? root.c.bg1 : root.c.bg
        color: danger && highlighted ? root.c.redBright
            : highlighted ? accent : baseBackground
        activeFocusOnTab: true
        
        StateAnim on color {}

        Row {
            anchors { fill: parent; leftMargin: 7; rightMargin: 7 }
            spacing: 8
            UiText {
                id: name
                width: parent.width - detailText.width - parent.spacing
                text: row.text
                color: row.danger && row.highlighted ? root.c.bg
                    : row.highlighted ? root.c.bg1
                    : row.danger ? root.c.redBright : root.c.fg1
                bold: row.highlighted
                elide: Text.ElideRight
            }
            UiText {
                id: detailText
                text: row.detail
                color: row.danger && row.highlighted ? root.c.bg
                    : row.highlighted ? root.c.bg1 : root.c.fg3
                horizontalAlignment: Text.AlignRight
            }
        }
        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: { row.forceActiveFocus(); row.activated() }
        }
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                row.activated()
                event.accepted = true
            }
        }
    }

    component ValueRow: Row {
        required property string label
        required property string value
        width: parent ? parent.width : implicitWidth
        spacing: 12
        UiText {
            width: parent.width * 0.38
            text: parent.label
            tone: "muted"
            elide: Text.ElideRight
        }
        UiText {
            width: parent.width - parent.width * 0.38 - parent.spacing
            text: parent.value
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideLeft
        }
    }

    component Meter: Rectangle {
        property real value: 0
        property bool warn: false
        property bool critical: false
        property color fillColor: critical ? root.c.redBright : warn ? root.c.yellowBright : root.c.orangeBright
        implicitHeight: 8
        color: root.c.bg2
        Rectangle {
            height: parent.height
            width: parent.width * root.clamp(parent.value, 0, 1)
            color: parent.fillColor

            MotionAnim on width {}
            StateAnim on color {}
        }
    }

    component MeterRow: Row {
        required property string label
        required property real value
        spacing: 8
        height: 22
        UiText {
            width: root.charWidth * 5
            text: parent.label
            tone: "muted"
            font.pixelSize: root.fontSize - 1
            elide: Text.ElideRight
        }
        Meter {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - root.charWidth * 10 - parent.spacing * 2
            value: parent.value / 100
            warn: parent.value >= 70
            critical: parent.value >= 90
        }
        UiText {
            width: root.charWidth * 5
            text: Math.round(parent.value) + "%"
            horizontalAlignment: Text.AlignRight
            font.pixelSize: root.fontSize - 1
        }
    }

    component HistoryGraph: Rectangle {
        id: graph
        required property var values
        property int warn: 75
        property int critical: 90
        implicitHeight: 60
        color: root.c.bg1
        border.width: root.borderWidth
        border.color: root.c.bg2

        MotionAnim on height {}
        StateAnim on color {}

        Row {
            anchors { fill: parent; margins: 7 }
            spacing: root.itemSpacing
            Repeater {
                model: ScriptModel { values: graph.values }
                Rectangle {
                    required property var modelData
                    width: Math.max(2, (parent.width - Math.max(0, graph.values.length - 1) * parent.spacing)
                        / Math.max(1, graph.values.length))
                    height: parent.height * Math.max(0.03, modelData / 100)
                    anchors.bottom: parent.bottom
                    color: modelData >= graph.critical ? root.c.redBright
                        : modelData >= graph.warn ? root.c.yellowBright : root.c.orangeBright
                }
            }
        }
    }

    component ProcessTable: Column {
        id: table
        required property var values
        spacing: root.itemSpacing
        readonly property real pidWidth: root.charWidth * 7
        readonly property real cpuWidth: root.charWidth * 7
        readonly property real memWidth: root.charWidth * 7
        readonly property real rssWidth: root.charWidth * 11
        readonly property real columnSpacing: 8

        Item {
            width: parent.width
            implicitHeight: processHeader.implicitHeight + 10
            Row {
                id: processHeader
                anchors { fill: parent; leftMargin: 7; rightMargin: 7 }
                spacing: table.columnSpacing
                UiText {
                    width: parent.width - table.pidWidth - table.cpuWidth - table.memWidth - table.rssWidth - parent.spacing * 4
                    text: "name"
                    tone: "quiet"
                    font.pixelSize: root.fontSize - 1
                }
                UiText { width: table.pidWidth; text: "pid"; tone: "quiet"; horizontalAlignment: Text.AlignRight; font.pixelSize: root.fontSize - 1 }
                UiText { width: table.cpuWidth; text: "cpu"; tone: "quiet"; horizontalAlignment: Text.AlignRight; font.pixelSize: root.fontSize - 1 }
                UiText { width: table.memWidth; text: "mem"; tone: "quiet"; horizontalAlignment: Text.AlignRight; font.pixelSize: root.fontSize - 1 }
                UiText { width: table.rssWidth; text: "rss"; tone: "quiet"; horizontalAlignment: Text.AlignRight; font.pixelSize: root.fontSize - 1 }
            }
        }

        Repeater {
            model: ScriptModel { values: table.values }
            Rectangle {
                required property var modelData
                required property int index
                width: table.width
                implicitHeight: processName.implicitHeight + 12
                color: index % 2 ? root.c.bg1 : root.c.bg
                Row {
                    anchors { fill: parent; leftMargin: 7; rightMargin: 7 }
                    spacing: table.columnSpacing
                    UiText {
                        id: processName
                        width: parent.width - table.pidWidth - table.cpuWidth - table.memWidth - table.rssWidth - parent.spacing * 4
                        text: modelData.name
                        bold: true
                        elide: Text.ElideRight
                    }
                    UiText { width: table.pidWidth; text: modelData.pid; tone: "quiet"; horizontalAlignment: Text.AlignRight }
                    UiText { width: table.cpuWidth; text: modelData.cpu.toFixed(1) + "%"; horizontalAlignment: Text.AlignRight }
                    UiText { width: table.memWidth; text: modelData.memory.toFixed(1) + "%"; tone: "muted"; horizontalAlignment: Text.AlignRight }
                    UiText { width: table.rssWidth; text: root.formatBytes(modelData.rss); tone: "muted"; horizontalAlignment: Text.AlignRight }
                }
            }
        }
    }

    component Header: Row {
        required property string title
        property string subtitle: ""
        property string actionText: ""
        property bool actionVisible: actionText !== ""
        property bool actionSelected: false
        property bool actionEnabled: true
        property color titleColor: root.c.fg1
        property color actionAccent: root.c.orangeBright
        signal action()

        width: parent ? parent.width : implicitWidth
        spacing: 8
        Column {
            width: parent.width - (action.visible ? action.width + parent.spacing : 0)
            spacing: root.itemSpacing
            UiText { text: parent.parent.title; color: parent.parent.titleColor; bold: true }
            UiText {
                visible: parent.parent.subtitle !== ""
                width: parent.width
                text: parent.parent.subtitle
                tone: "muted"
                elide: Text.ElideRight
            }
        }
        Button {
            id: action
            visible: parent.actionVisible
            enabled: parent.actionEnabled
            text: parent.actionText
            selected: parent.actionSelected
            accent: parent.actionAccent
            onActivated: parent.action()
        }
    }

    component VolumeSlider: Rectangle {
        id: slider
        required property real value
        property color fillColor: root.c.orangeBright
        signal changed(real value)
        implicitHeight: 20
        color: "transparent"
        activeFocusOnTab: true

        function setAt(x) { changed(root.clamp(x / width, 0, 1)) }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            implicitHeight: 6
            color: root.c.bg2
        }
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * root.clamp(slider.value, 0, 1)
            implicitHeight: 6
            color: slider.fillColor

            MotionAnim on width {}
        }
        Rectangle {
            implicitWidth: 6
            implicitHeight: 14
            x: root.clamp(parent.width * slider.value - width / 2, 0, parent.width - width)
            anchors.verticalCenter: parent.verticalCenter
            color: slider.activeFocus ? slider.fillColor : root.c.fg1

            MotionAnim on width {}
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: mouse => { slider.forceActiveFocus(); slider.setAt(mouse.x) }
            onPositionChanged: mouse => { if (pressed) slider.setAt(mouse.x) }
        }
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Left || event.key === Qt.Key_Down) {
                slider.changed(root.clamp(slider.value - 0.05, 0, 1))
                event.accepted = true
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Up) {
                slider.changed(root.clamp(slider.value + 0.05, 0, 1))
                event.accepted = true
            }
        }
    }

    component MenuPopup: PopupWindow {
        id: popupWindow
        required property var owner
        required property Item anchorItem
        property int popupWidth: 380
        property int popupEdges: Edges.Bottom | Edges.Right
        property int popupGravity: Edges.Bottom | Edges.Left
        property int contentSpacing: root.itemSpacing
        property int contentPadding: 10
        property bool requestedVisible: false
        property bool surfaceVisible: false
        property real slideOffsetY: 0
        readonly property real popupEnterOffsetY: -Math.max(
            implicitHeight + (anchorItem ? anchorItem.height : 0) + root.itemSpacing * 2,
            1
        )
        default property alias content: body.data
        signal keyPressed(var event)

        function showAnimated() {
            requestedVisible = true
            popupExit.stop()

            if (!root.animationsEnabled) {
                slideOffsetY = 0
                popupSurface.opacity = 1
                popupSurface.scale = 1
                surfaceVisible = true
                Qt.callLater(() => body.forceActiveFocus())
                return
            }

            slideOffsetY = popupEnterOffsetY
            popupSurface.opacity = 0
            popupSurface.scale = root.windowEnterScale
            surfaceVisible = true
            popupEnter.restart()
            Qt.callLater(() => body.forceActiveFocus())
        }

        function hideAnimated() {
            requestedVisible = false
            popupEnter.stop()

            if (!surfaceVisible) return
            if (!root.animationsEnabled) {
                surfaceVisible = false
                slideOffsetY = popupEnterOffsetY
                popupSurface.opacity = 0
                popupSurface.scale = root.windowEnterScale
                return
            }

            popupExit.restart()
        }

        anchor.item: anchorItem
        anchor.edges: popupEdges
        anchor.gravity: popupGravity
        // Keep horizontal on-screen correction, but allow the Y animation to travel off-screen.
        anchor.adjustment: PopupAdjustment.SlideX
        anchor.rect.x: 0
        anchor.rect.y: slideOffsetY
        anchor.rect.width: anchorItem ? Math.max(anchorItem.width, 1) : 1
        anchor.rect.height: anchorItem ? Math.max(anchorItem.height, 1) : 1
        onSlideOffsetYChanged: {
            if (surfaceVisible) anchor.updateAnchor()
        }
        // PopupWindow's native grab is dismissed when an unrelated Wayland
        // surface (such as the transient notification window) is unmapped.
        // Let Hyprland track the intended popup windows explicitly instead.
        grabFocus: false
        visible: surfaceVisible
        implicitWidth: popupWidth
        implicitHeight: body.implicitHeight + (contentPadding + root.borderWidth) * 2
        color: "transparent"

        HyprlandFocusGrab {
            id: popupFocusGrab
            windows: [popupWindow.owner, popupWindow]
            active: popupWindow.requestedVisible && popupWindow.surfaceVisible

            onCleared: {
                if (popupWindow.requestedVisible) popupWindow.hideAnimated()
            }
        }

        Rectangle {
            id: popupSurface
            anchors.fill: parent
            color: root.c.bg
            border.width: root.borderWidth
            border.color: root.c.bg2
            opacity: 0
            scale: root.windowEnterScale
            transformOrigin: Item.Top

            Column {
                id: body
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    topMargin: popupWindow.contentPadding + root.borderWidth
                    leftMargin: popupWindow.contentPadding + root.borderWidth
                    rightMargin: popupWindow.contentPadding + root.borderWidth
                }
                spacing: popupWindow.contentSpacing
                focus: popupWindow.requestedVisible
                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        popupWindow.owner.closePopups()
                        event.accepted = true
                    } else {
                        popupWindow.keyPressed(event)
                    }
                }
            }
        }

        ParallelAnimation {
            id: popupEnter
            NumberAnimation {
                target: popupSurface
                property: "opacity"
                to: 1
                duration: root.animDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.almostLinear
            }
            NumberAnimation {
                target: popupSurface
                property: "scale"
                to: 1
                duration: root.animDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.easeOutQuint
            }
            NumberAnimation {
                target: popupWindow
                property: "slideOffsetY"
                to: 0
                duration: root.animDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.easeOutQuint
            }
        }

        ParallelAnimation {
            id: popupExit
            NumberAnimation {
                target: popupSurface
                property: "opacity"
                to: 0
                duration: root.animDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.almostLinear
            }
            NumberAnimation {
                target: popupSurface
                property: "scale"
                to: root.windowExitScale
                duration: root.animDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.quick
            }
            NumberAnimation {
                target: popupWindow
                property: "slideOffsetY"
                to: popupWindow.popupEnterOffsetY
                duration: root.animDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.quick
            }
            onStopped: {
                if (!popupWindow.requestedVisible) {
                    popupWindow.surfaceVisible = false
                    popupWindow.slideOffsetY = popupWindow.popupEnterOffsetY
                    popupSurface.opacity = 0
                    popupSurface.scale = root.windowEnterScale
                }
            }
        }
    }

    component BarModule: Rectangle {
        id: module
        required property string text
        property int fixedCharacters: 0
        property color normalBackground: root.c.bg
        property color normalForeground: root.c.fg1
        property color hoverBackground: root.c.orangeBright
        property bool lockHoverBackground: false
        property bool lockHoverForeground: false
        property bool bold: false
        signal wheelUp()
        signal wheelDown()
        signal activated()

        readonly property bool hovered: mouse.containsMouse
        implicitWidth: (fixedCharacters ? root.charWidth * fixedCharacters : label.implicitWidth) + root.padX * 2
        implicitHeight: label.implicitHeight + root.padY * 2
        color: hovered && !lockHoverBackground ? hoverBackground : normalBackground

        StateAnim on color {}

        UiText {
            id: label
            anchors.centerIn: parent
            width: module.fixedCharacters ? root.charWidth * module.fixedCharacters : implicitWidth
            text: module.text
            color: module.hovered && !module.lockHoverForeground ? root.c.bg1 : module.normalForeground
            bold: module.bold || module.hovered
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight

            StateAnim on color {}
        }
        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: module.activated()
            onWheel: wheel => {
                if (wheel.angleDelta.y > 0) module.wheelUp()
                else if (wheel.angleDelta.y < 0) module.wheelDown()
            }
        }
    }

    // Moving/changing geometry: Hyprland easeOutQuint.
    component MotionAnim: Behavior {
        enabled: root.animationsEnabled

        NumberAnimation {
            duration: root.animDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: root.easeOutQuint
        }
    }

    // Generic state/color transitions: Hyprland "quick".
    component StateAnim: Behavior {
        enabled: root.animationsEnabled

        ColorAnimation {
            duration: root.animDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: root.quick
        }
    }

    // Fade in/out: Hyprland almostLinear.
    component FadeAnim: Behavior {
        enabled: root.animationsEnabled

        NumberAnimation {
            duration: root.animDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: root.almostLinear
        }
    }
    
    // Notifications.
    property bool notificationDnd: false
    property bool notificationCenterOpen: false
    property var notificationPopups: []
    property var notificationHistory: []
    readonly property int notificationMaxPopups: 5
    readonly property int notificationHistoryLimit: 100

    function notificationTimeout(n) {
        if (n.urgency === NotificationUrgency.Critical || n.expireTimeout === 0) return 0
        if (n.expireTimeout > 0) return Math.round(n.expireTimeout * 1000)
        return n.urgency === NotificationUrgency.Low ? 3000 : 5000
    }

    function notificationImage(n) {
        if (n.image) return n.image
        if (!n.appIcon) return ""
        if (n.appIcon.includes("/") || n.appIcon.includes(":")) return n.appIcon
        return Quickshell.iconPath(n.appIcon, true)
    }

    function notificationBar(screen) {
        for (const b of bars.instances) if (b.screen === screen) return b
        return null
    }

    function addNotificationHistory(n) {
        if (n.transient) return

        const next = notificationHistory.filter(x => x.id !== n.id)
        next.unshift({
            id: n.id,
            appName: n.appName || "notification",
            summary: n.summary,
            body: n.body,
            urgency: n.urgency,
            time: Qt.formatDateTime(new Date(), "yyyy-MM-dd HH:mm")
        })

        notificationHistory = next.slice(0, notificationHistoryLimit)
    }

    function showNotification(n) {
        const next = notificationPopups.filter(x => x.id !== n.id)
        const dropped = []

        next.unshift(n)
        while (next.length > notificationMaxPopups) dropped.push(next.pop())

        notificationPopups = next
        for (const old of dropped) old.expire()
    }

    function removeNotification(id) {
        notificationPopups = notificationPopups.filter(n => n.id !== id)
    }

    function dismissNotification(n) {
        removeNotification(n.id)
        n.dismiss()
    }

    function expireNotification(n) {
        removeNotification(n.id)
        n.expire()
    }

    function dismissLatestNotification() {
        if (notificationPopups.length) dismissNotification(notificationPopups[0])
    }

    function dismissAllNotifications() {
        const current = notificationPopups.slice()
        notificationPopups = []
        for (const n of current) n.dismiss()
    }

    function clearNotificationHistory() {
        notificationHistory = []
    }

    function toggleNotificationDnd() {
        notificationDnd = !notificationDnd
        return notificationDnd
    }

    function toggleNotificationCenter() {
        const show = !notificationCenterOpen
        if (show) closePopups()
        notificationCenterOpen = show
        return notificationCenterOpen
    }

    NotificationServer {
        id: notificationServer

        actionsSupported: true
        imageSupported: true
        persistenceSupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: false
        actionIconsSupported: false
        inlineReplySupported: false

        // Do not replay notifications every time this config is edited.
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true
            root.addNotificationHistory(notification)

            const critical = notification.urgency === NotificationUrgency.Critical
            if (root.notificationDnd && !critical) {
                notification.expire()
                return
            }

            root.showNotification(notification)
        }
    }

    // Notification popups appear below the bar on the focused monitor.
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: notificationWindow
            required property var modelData

            readonly property var hyprMonitor: Hyprland.monitorFor(screen)
            readonly property var screenBar: root.notificationBar(screen)

            screen: modelData
            aboveWindows: true
            exclusionMode: ExclusionMode.Ignore
            color: "transparent"

            anchors {
                top: true
                right: true
            }

            margins {
                top: (screenBar ? screenBar.height : 0) + root.itemSpacing
                right: root.itemSpacing
            }

            implicitWidth: 420
            implicitHeight: notificationColumn.implicitHeight

            visible: root.notificationPopups.length > 0
                && !root.notificationCenterOpen
                && hyprMonitor
                && hyprMonitor.focused

            Column {
                id: notificationColumn
                width: parent.width
                spacing: root.itemSpacing

                Repeater {
                    model: ScriptModel { values: root.notificationPopups }

                    NotificationCard {
                        required property var modelData

                        width: notificationColumn.width
                        notification: modelData
                    }
                }
            }
        }
    }

    // Notification history / DND panel.
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: notificationCenter
            required property var modelData

            readonly property var hyprMonitor: Hyprland.monitorFor(screen)
            readonly property var screenBar: root.notificationBar(screen)
            readonly property bool shouldShow: root.notificationCenterOpen
                && hyprMonitor
                && hyprMonitor.focused
            property bool surfaceVisible: false
            property real animatedRightMargin: root.itemSpacing
            readonly property real hiddenRightMargin: -implicitWidth

            function showAnimated() {
                notificationCenterExit.stop()

                if (!root.animationsEnabled) {
                    animatedRightMargin = root.itemSpacing
                    notificationCenterBody.opacity = 1
                    notificationCenterBody.scale = 1
                    surfaceVisible = true
                    Qt.callLater(() => notificationCenterBody.forceActiveFocus())
                    return
                }

                animatedRightMargin = hiddenRightMargin
                notificationCenterBody.opacity = 0
                notificationCenterBody.scale = root.windowEnterScale
                surfaceVisible = true
                notificationCenterEnter.restart()
                Qt.callLater(() => notificationCenterBody.forceActiveFocus())
            }

            function hideAnimated() {
                notificationCenterEnter.stop()

                if (!surfaceVisible) return
                if (!root.animationsEnabled) {
                    surfaceVisible = false
                    animatedRightMargin = hiddenRightMargin
                    notificationCenterBody.opacity = 0
                    notificationCenterBody.scale = root.windowEnterScale
                    return
                }

                notificationCenterExit.restart()
            }

            onShouldShowChanged: {
                if (shouldShow) showAnimated()
                else hideAnimated()
            }
            Component.onCompleted: {
                if (shouldShow) showAnimated()
            }

            screen: modelData
            aboveWindows: true
            exclusionMode: ExclusionMode.Ignore
            focusable: true
            color: "transparent"

            anchors {
                top: true
                right: true
                bottom: true
            }

            margins {
                top: (screenBar ? screenBar.height : 0) + root.itemSpacing
                right: notificationCenter.animatedRightMargin
                bottom: root.itemSpacing
            }

            implicitWidth: 440
            visible: surfaceVisible

            Rectangle {
                id: notificationCenterBody
                anchors.fill: parent
                color: root.c.bg
                border.width: root.borderWidth
                border.color: root.c.bg2
                focus: notificationCenter.shouldShow
                opacity: 0
                scale: root.windowEnterScale
                transformOrigin: Item.TopRight

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        root.notificationCenterOpen = false
                        event.accepted = true
                    }
                }

                Column {
                    id: notificationCenterHeader

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        topMargin: 10 + root.borderWidth
                        leftMargin: 10 + root.borderWidth
                        rightMargin: 10 + root.borderWidth
                    }

                    spacing: root.itemSpacing

                    Header {
                        title: "notifications"
                        titleColor: root.c.orangeBright
                        subtitle: root.notificationHistory.length
                            + (root.notificationHistory.length === 1 ? " stored" : " stored")

                        actionText: root.notificationDnd ? "dnd:on" : "dnd:off"
                        actionSelected: root.notificationDnd
                        actionAccent: root.c.yellowBright
                        onAction: root.toggleNotificationDnd()
                    }

                    Row {
                        width: parent.width
                        spacing: root.itemSpacing

                        Button {
                            text: "dismiss"
                            enabled: root.notificationPopups.length > 0
                            onActivated: root.dismissAllNotifications()
                        }

                        Button {
                            text: "clear"
                            enabled: root.notificationHistory.length > 0
                            onActivated: root.clearNotificationHistory()
                        }

                        Button {
                            text: "close"
                            onActivated: root.notificationCenterOpen = false
                        }
                    }

                    Item {
                        width: parent.width
                        height: root.listTopPadding
                    }

                    Divider { width: parent.width }
                }

                Flickable {
                    id: notificationHistoryView

                    anchors {
                        top: notificationCenterHeader.bottom
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                        topMargin: root.itemSpacing
                        bottomMargin: 10 + root.borderWidth
                        leftMargin: 10 + root.borderWidth
                        rightMargin: 10 + root.borderWidth
                    }

                    contentWidth: width
                    contentHeight: notificationHistoryColumn.implicitHeight
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true

                    Column {
                        id: notificationHistoryColumn
                        width: parent.width
                        spacing: root.itemSpacing

                        UiText {
                            visible: root.notificationHistory.length === 0
                            width: parent.width
                            text: "no notifications"
                            tone: "muted"
                        }

                        Repeater {
                            model: ScriptModel { values: root.notificationHistory }

                            NotificationHistoryRow {
                                required property var modelData
                                required property int index

                                width: notificationHistoryColumn.width
                                entry: modelData
                                alternate: index % 2 === 1
                            }
                        }
                    }
                }
            }

            ParallelAnimation {
                id: notificationCenterEnter
                NumberAnimation {
                    target: notificationCenterBody
                    property: "opacity"
                    to: 1
                    duration: root.animDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: root.almostLinear
                }
                NumberAnimation {
                    target: notificationCenterBody
                    property: "scale"
                    to: 1
                    duration: root.animDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: root.easeOutQuint
                }
                NumberAnimation {
                    target: notificationCenter
                    property: "animatedRightMargin"
                    to: root.itemSpacing
                    duration: root.animDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: root.easeOutQuint
                }
            }

            ParallelAnimation {
                id: notificationCenterExit
                NumberAnimation {
                    target: notificationCenterBody
                    property: "opacity"
                    to: 0
                    duration: root.animDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: root.almostLinear
                }
                NumberAnimation {
                    target: notificationCenterBody
                    property: "scale"
                    to: root.windowExitScale
                    duration: root.animDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: root.quick
                }
                NumberAnimation {
                    target: notificationCenter
                    property: "animatedRightMargin"
                    to: notificationCenter.hiddenRightMargin
                    duration: root.animDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: root.quick
                }
                onStopped: {
                    if (!notificationCenter.shouldShow) {
                        notificationCenter.surfaceVisible = false
                        notificationCenter.animatedRightMargin = notificationCenter.hiddenRightMargin
                        notificationCenterBody.opacity = 0
                        notificationCenterBody.scale = root.windowEnterScale
                    }
                }
            }
        }
    }

    component NotificationCard: Rectangle {
        id: notificationCard
        required property var notification

        readonly property real notificationEnterY: -Math.max(implicitHeight, 1)
        readonly property bool critical:
            notification.urgency === NotificationUrgency.Critical
        readonly property string iconSource: root.notificationImage(notification)

        implicitHeight: notificationContent.implicitHeight
            + (10 + root.borderWidth) * 2

        opacity: root.animationsEnabled ? 0 : 1
        scale: root.animationsEnabled ? root.windowEnterScale : 1
        transformOrigin: Item.TopRight
        transform: Translate {
            id: notificationSlide
            y: root.animationsEnabled ? notificationCard.notificationEnterY : 0
        }
        Component.onCompleted: {
            if (root.animationsEnabled) notificationEnter.restart()
        }

        ParallelAnimation {
            id: notificationEnter
            NumberAnimation {
                target: notificationCard
                property: "opacity"
                to: 1
                duration: root.animDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.almostLinear
            }
            NumberAnimation {
                target: notificationCard
                property: "scale"
                to: 1
                duration: root.animDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.easeOutQuint
            }
            NumberAnimation {
                target: notificationSlide
                property: "y"
                to: 0
                duration: root.animDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.easeOutQuint
            }
        }

        color: root.c.bg
        border.width: root.borderWidth
        border.color: critical ? root.c.redBright : root.c.bg2

        Timer {
            interval: root.notificationTimeout(notificationCard.notification)
            running: interval > 0
            repeat: false
            onTriggered: root.expireNotification(notificationCard.notification)
        }

        Connections {
            target: notificationCard.notification

            function onClosed(reason) {
                root.removeNotification(notificationCard.notification.id)
            }
        }

        Row {
            id: notificationContent

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 10 + root.borderWidth
            }

            spacing: 10

            Image {
                width: notificationCard.iconSource ? 36 : 0
                height: width
                visible: notificationCard.iconSource !== ""
                source: notificationCard.iconSource
                fillMode: Image.PreserveAspectFit
                asynchronous: true
            }

            Column {
                width: parent.width
                    - (notificationCard.iconSource ? 36 + parent.spacing : 0)

                spacing: root.itemSpacing

                Row {
                    width: parent.width
                    spacing: 8

                    UiText {
                        width: parent.width - closeNotification.width - parent.spacing
                        text: notificationCard.notification.appName || "notification"
                        color: notificationCard.critical
                            ? root.c.redBright : root.c.fg3
                        bold: notificationCard.critical
                        elide: Text.ElideRight
                    }

                    Button {
                        id: closeNotification
                        text: "x"
                        tabStop: false
                        foreground: root.c.fg3
                        onActivated:
                            root.dismissNotification(notificationCard.notification)
                    }
                }

                UiText {
                    visible: text !== ""
                    width: parent.width
                    text: notificationCard.notification.summary
                    bold: true
                    wrapMode: Text.Wrap
                    textFormat: Text.PlainText
                }

                UiText {
                    visible: text !== ""
                    width: parent.width
                    text: notificationCard.notification.body
                    tone: "muted"
                    wrapMode: Text.Wrap
                    textFormat: Text.PlainText
                }

                Flow {
                    visible: notificationCard.notification.actions.length > 0
                    width: parent.width
                    spacing: root.itemSpacing

                    Repeater {
                        model: notificationCard.notification.actions

                        Button {
                            required property var modelData

                            text: modelData.text || "action"
                            accent: notificationCard.critical
                                ? root.c.redBright : root.c.orangeBright

                            onActivated: {
                                root.removeNotification(notificationCard.notification.id)
                                modelData.invoke()
                            }
                        }
                    }
                }
            }
        }
    }

    component NotificationHistoryRow: Rectangle {
        id: historyRow
        required property var entry
        property bool alternate: false

        implicitHeight: historyContent.implicitHeight + 14

        color: alternate ? root.c.bg1 : root.c.bg
        border.width: entry.urgency === NotificationUrgency.Critical
            ? root.borderWidth : 0
        border.color: root.c.redBright

        Column {
            id: historyContent

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 7
            }

            spacing: root.itemSpacing

            Row {
                width: parent.width
                spacing: 8

                UiText {
                    width: parent.width - historyTime.width - parent.spacing
                    text: historyRow.entry.appName
                    color: historyRow.entry.urgency === NotificationUrgency.Critical
                        ? root.c.redBright : root.c.fg3
                    bold: historyRow.entry.urgency === NotificationUrgency.Critical
                    elide: Text.ElideRight
                }

                UiText {
                    id: historyTime
                    text: historyRow.entry.time
                    tone: "quiet"
                }
            }

            UiText {
                visible: text !== ""
                width: parent.width
                text: historyRow.entry.summary
                bold: true
                wrapMode: Text.Wrap
                textFormat: Text.PlainText
            }

            UiText {
                visible: text !== ""
                width: parent.width
                text: historyRow.entry.body
                tone: "muted"
                wrapMode: Text.Wrap
                textFormat: Text.PlainText
            }
        }
    }
    // Replace Quickshell's built-in reload popup with our notification system.
    Connections {
        target: Quickshell

        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup()
            root.notify("Quickshell", "Quickshell reloaded")
        }

        function onReloadFailed(error) {
            Quickshell.inhibitReloadPopup()
            root.notify("Quickshell", "Quickshell reload failed", error, "critical")
        }
    }

    // Surface Hyprland config reloads through the same notification system.
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "configreloaded")
                root.notify("Hyprland", "Hyprland config reloaded")
        }
    }
}

