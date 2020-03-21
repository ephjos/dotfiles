
FROM archlinux

# Install packages
RUN \
  pacman -Sy --noconfirm \
    base-devel curl git htop man unzip vim wget \
    neovim nodejs npm cmake python3 python python-pip ghc

# Custom installs/setup
RUN \
	pip3 install virtualenv future neovim

# Copy dotfiles
COPY ./bash/ /root
COPY ./vim/ /root/.config/nvim
COPY ./scripts/ /root/.local/bin
COPY ./.cabal/ /root/.cabal

WORKDIR /root

# Install dotfiles
RUN \
	ln -sv .config/nvim .vim && \
	ln -sv .config/nvim/init.vim .vimrc && \
	ln -sv .profile .bash_profile

# Final update
RUN pacman -Syyuu --noconfirm

WORKDIR /mounted

# Define default command.
CMD ["bash"]

