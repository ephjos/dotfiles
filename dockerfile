
FROM ubuntu:18.04

# Install packages
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  apt-get install -y neovim nodejs npm python3 python3-pip python && \
  rm -rf /var/lib/apt/lists/*

# Custom installs/setup
RUN \
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
	~/.fzf/install && \
	pip3 install virtualenv && \
	npm install -g yarn

# Copy dotfiles
COPY ./bash/lib/ /root
WORKDIR /root

# Install dotfiles
RUN \
	ln -sv ~/.config/nvim .vim && \
	ln -sv ~/.config/nvim/init.vim .vimrc && \
	ln -sv ~/.profile ~/.bash_profile

RUN \
	yes | curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

WORKDIR /mounted

# Define default command.
CMD ["bash"]

