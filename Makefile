SHELL := /bin/bash

K9S_VERSION ?= v0.50.18
NVM_VERSION ?= v0.40.3
PYTHON_VERSION ?= 3.13.12
GO_VERSION ?= 1.22.5

.PHONY: install-pyenv
install-pyenv:
	sudo apt update && sudo apt upgrade -y
	sudo apt install -y make build-essential libssl-dev zlib1g-dev \
	libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
	libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
	liblzma-dev git
	if [ ! -d "$$HOME/.pyenv" ]; then curl https://pyenv.run | bash; else echo "pyenv já existe em $$HOME/.pyenv, pulando instalação"; fi
	grep -qxF 'export PATH="$$HOME/.pyenv/bin:$$PATH"' ~/.bashrc || echo 'export PATH="$$HOME/.pyenv/bin:$$PATH"' >> ~/.bashrc
	grep -qxF 'eval "$$(pyenv init -)"' ~/.bashrc || echo 'eval "$$(pyenv init -)"' >> ~/.bashrc
	grep -qxF 'eval "$$(pyenv virtualenv-init -)"' ~/.bashrc || echo 'eval "$$(pyenv virtualenv-init -)"' >> ~/.bashrc
	bash -lc 'export PYENV_ROOT="$$HOME/.pyenv"; export PATH="$$PYENV_ROOT/bin:$$PATH"; eval "$$(pyenv init -)"; pyenv install -s $(PYTHON_VERSION); pyenv global $(PYTHON_VERSION)'

.PHONY: install-nvm
install-nvm:
	sudo apt update && sudo apt upgrade -y
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(NVM_VERSION)/install.sh | bash
	grep -qxF 'export NVM_DIR="$$HOME/.nvm"' ~/.bashrc || echo 'export NVM_DIR="$$HOME/.nvm"' >> ~/.bashrc
	grep -qxF '[ -s "$$NVM_DIR/nvm.sh" ] && \. "$$NVM_DIR/nvm.sh"' ~/.bashrc || echo '[ -s "$$NVM_DIR/nvm.sh" ] && \. "$$NVM_DIR/nvm.sh"' >> ~/.bashrc
	grep -qxF '[ -s "$$NVM_DIR/bash_completion" ] && \. "$$NVM_DIR/bash_completion"' ~/.bashrc || echo '[ -s "$$NVM_DIR/bash_completion" ] && \. "$$NVM_DIR/bash_completion"' >> ~/.bashrc
	bash -lc 'export NVM_DIR="$$HOME/.nvm"; [ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh"; [ -s "$$NVM_DIR/bash_completion" ] && . "$$NVM_DIR/bash_completion"; nvm install --lts; nvm alias default lts/*'

.PHONY: install-docker
install-docker:
	sudo apt update
	sudo apt install ca-certificates curl gnupg lsb-release -y
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update
	sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	if getent group docker >/dev/null 2>&1; then sudo usermod -aG docker $$(id -un); else echo "grupo docker não encontrado, pulando usermod"; fi

.PHONY: install-k8s-tools
install-k8s-tools:
	sudo apt update && sudo apt upgrade -y
	curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
	curl -LO "https://dl.k8s.io/release/$$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl
	wget https://github.com/derailed/k9s/releases/download/$(K9S_VERSION)/k9s_Linux_amd64.tar.gz -O /tmp/k9s.tar.gz
	tar -zxvf /tmp/k9s.tar.gz --directory /tmp/
	chmod +x /tmp/k9s
	sudo mv /tmp/k9s /usr/local/bin/k9s
	rm /tmp/k9s.tar.gz

.PHONY: install-goenv
install-goenv:
	sudo apt update
	sudo apt install -y git curl build-essential
	if [ ! -d "$$HOME/.goenv" ]; then git clone https://github.com/syndbg/goenv.git $$HOME/.goenv; fi
	grep -qxF 'export GOENV_ROOT="$$HOME/.goenv"' ~/.bashrc || echo 'export GOENV_ROOT="$$HOME/.goenv"' >> ~/.bashrc
	grep -qxF 'export PATH="$$GOENV_ROOT/bin:$$PATH"' ~/.bashrc || echo 'export PATH="$$GOENV_ROOT/bin:$$PATH"' >> ~/.bashrc
	grep -qxF 'eval "$$(goenv init -)"' ~/.bashrc || echo 'eval "$$(goenv init -)"' >> ~/.bashrc
	bash -lc 'export GOENV_ROOT="$$HOME/.goenv"; export PATH="$$GOENV_ROOT/bin:$$PATH"; eval "$$(goenv init -)"; goenv install -s $(GO_VERSION); goenv global $(GO_VERSION)'

.PHONY: install-uv
install-uv:
	curl -LsSf https://astral.sh/uv/install.sh | sh
	grep -qxF 'export PATH="$$HOME/.local/bin:$$PATH"' ~/.bashrc || echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> ~/.bashrc

.PHONY: install-all
install-all: install-pyenv install-nvm install-docker install-k8s-tools install-goenv install-uv
