
FROM archlinux

# Install packages
RUN \
  pacman -Sy --noconfirm \
    base-devel curl git htop man unzip vim wget \
    neovim nodejs npm cmake python3 python python-pip ghc \
    ripgrep cabal-install

USER root
WORKDIR /

# Custom installs/setup
RUN \
	pip3 install virtualenv future neovim

# Setup user
ARG user=user
ARG HOMEDIR=/home/$user
RUN useradd -m $user
RUN echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user

# Switch to user
USER $user
WORKDIR $HOMEDIR

# Copy dotfiles
COPY ./.bashrc $HOMEDIR
COPY ./.profile $HOMEDIR
COPY ./.config/ $HOMEDIR/.config
COPY ./.local/ $HOMEDIR/.local
COPY ./.cabal/ $HOMEDIR/.cabal

# Ensure $user owns their files
USER root
RUN \
  chown -R user:user $HOMEDIR/.*
USER $user

# Install dotfiles
RUN \
	ln -sv .config/nvim .vim && \
	ln -sv .config/nvim/init.vim .vimrc && \
  rm -f .bash_profile && \
	ln -sv .profile .bash_profile

# Install yay
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -sri --needed --noconfirm \
  && cd \
  && rm -rf .cache yay

# Final update
RUN yay -Syyuu --noconfirm

WORKDIR /mounted

# Define default command.
CMD ["bash"]

