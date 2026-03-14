# 🐧 Guia Completo: Instalação e uso do WSL no Windows

Este guia explica como **remover instalações antigas do WSL**, configurar um ambiente novo, instalar e gerenciar ferramentas como **pyenv**, **Docker**, **NVM**, **goenv**, **Kubernetes (Minikube, kubectl e K9s)**, entre outras, além de usar o **VSCode** de forma otimizada no Linux e trazer dicas de boas práticas, configuração de Git e SSH.

## 📋 Sumário

> ⚠️ **Atenção:** A instalação e configuração base do WSL é finalizada no passo 7, os demais passos são opcionais de acordo com a necessidade do usuário.

0. [🧹 Remover instalação antiga do WSL se necessário](#-0-remover-instalação-antiga-do-wsl-se-necessário)
1. [🧩 Habilitar recursos necessários do Windows](#-1-habilitar-os-recursos-necessários-do-windows)
2. [🐧 Instalar e configurar o WSL](#-2-instalar-e-configurar-o-wsl)
3. [🧱 Acessar o terminal Linux](#-3-acessar-o-terminal-linux)
4. [🧰 Configuração do Git](#-4-configuração-do-git)
5. [🗝️ Configuração de SSH](#️-5-configuração-de-ssh)
6. [✔ Boas práticas no WSL](#-6-boas-práticas-no-wsl)
7. [💻 Usar o VSCode com o WSL](#-7-usar-o-vscode-com-o-wsl)
8. [🐍 Instalação do pyenv](#-8-instalação-do-pyenv)
9. [🟩 Instalação do NVM](#-9-instalação-do-nvm)
10. [🐳 Instalação do Docker engine](#-10-instalação-do-docker-engine)
11. [☸️ Instalação do Minikube, kubectl e k9s](#️-11-instalação-do-minikube-kubectl-e-k9s)
12. [🚀 Instalação do goenv](#-12-instalação-do-goenv)
13. [⚡ Instalação do UV](#-13-instalação-do-uv)

---

## 🧹 0. Remover instalação antiga do WSL se necessário

Antes de instalar o WSL novamente, é recomendado **remover distribuições antigas e seus discos virtuais (VHDX)**, especialmente se você quer um ambiente totalmente limpo.

### 🔎 0.1 — Listar distribuições existentes

Abra o PowerShell e execute:

```powershell
wsl --list --verbose
```

Exemplo de saída:

```
  NAME                   STATE           VERSION
* Ubuntu-22.04           Stopped         2
  docker-desktop         Stopped         2
  docker-desktop-data    Stopped         2
```

---

### 🧯 0.2 — Encerrar e desinstalar distribuições

Pare todas as distribuições:

```powershell
wsl --shutdown
```

Desinstale cada uma (substitua `<Nome>` pelo nome exato mostrado na listagem):

```powershell
wsl --unregister <Nome>
```

Exemplo:

```powershell
wsl --unregister Ubuntu-22.04
wsl --unregister docker-desktop
wsl --unregister docker-desktop-data
```

Isso **remove completamente as distribuições**, incluindo arquivos, pacotes e configurações.

---

### 🧱 0.3 — Remover discos virtuais (VHDX)

Os arquivos `.vhdx` ficam em:

```
%LOCALAPPDATA%\Packages\
```

Procure por pastas com nomes como:

```
CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc
```

Para limpar completamente:

1. Feche **VSCode**, **Docker/Podman** e todos os terminais.
2. Exclua as pastas relacionadas ao WSL.
3. Esvazie a lixeira (opcional).

> ⚠️ Atenção: Isso apaga permanentemente todos os arquivos e ambientes dentro do Linux.

---

### ✅ 0.4 — Confirmar que o ambiente está limpo

```powershell
wsl --list
```

Se não aparecer nenhuma distribuição, está pronto para uma nova instalação.

---

## 🧩 1. Habilitar os recursos necessários do Windows

Abra o **PowerShell como Administrador** e execute:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
dism.exe /online /enable-feature /featurename:HypervisorPlatform /all /norestart
shutdown /r /t 0
```

Esses comandos ativam:

* O **WSL**
* A **Virtual Machine Platform**
* A **Windows Hypervisor Platform**

O computador será reiniciado para aplicar as alterações.

---

## 🐧 2. Instalar e configurar o WSL

Após o reboot, abra o PowerShell (modo normal) e execute:

```powershell
wsl --set-default-version 2
wsl --install
wsl --update
```

Esses comandos:

* Definem o **WSL 2** como padrão (melhor desempenho)
* Instalam o **Ubuntu** (distribuição padrão)
* Atualizam o kernel

---

## 🧱 3. Acessar o terminal Linux

Após a instalação:

* Abra o aplicativo **Ubuntu** no menu Iniciar.
* Crie seu **usuário e senha Linux**.

> **Observação**: Também é possível acessar o Ubuntu pelo Windows Terminal.

---

## 🧰 4. Configuração do Git

Após instalar o Git (ele já vem com o Ubuntu, mas pode ser atualizado), configure suas credenciais e cache de autenticação.

### 4.1 — Verifique se o Git está instalado

```bash
git --version
```

Se precisar instalar:

```bash
sudo apt install git -y
```

---

### 4.2 — Configure o nome e e-mail globais

> Essas informações aparecem nos commits.

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@empresa.com"
```

Verifique:

```bash
git config --list
```

---

### 4.3 — Habilitar o Credential Manager

Isso permite salvar tokens de acesso do GitHub, Azure DevOps, Bitbucket etc., de forma segura.

> Importante: é necessário ter o Git instalado no Windows, pois o Git Credential Manager (GCM) já vem integrado nele e é compatível com o WSL.

#### Passo 1 — Definir a configuração global

```bash
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

> ⚠️ **Atenção:** O caminho `/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe` é o padrão para a maioria das instalações do Git no Windows.  
> Caso o comando retorne erro, verifique onde o Git está instalado no seu sistema e ajuste o caminho conforme necessário.

---

### 5.1 — Gerar chave SSH

Execute no terminal:
```bash
ssh-keygen -t ed25519 -C "seu_email@example.com"
```

Caso seu sistema não suporte ed25519, utilize:
```bash
ssh-keygen -t rsa -b 4096 -C "seu_email@example.com"
```

---

### 5.2 — Copiar a chave pública

Exiba o conteúdo da chave pública:
```bash
cat ~/.ssh/id_ed25519.pub
```

Copie toda a saída do terminal.

---

### 5.3 — Adicionar chave ao GitHub

* Acesse as configurações de SSH keys: [https://github.com/settings/keys](https://github.com/settings/keys)
* Clique em **New SSH key**
* Preencha:
  * **Title**: Nome do dispositivo (ex: wsl-dev)
  * **Key**: Cole a chave pública copiada anteriormente
  * **Key type**: Authentication Key
* Clique em **Add SSH key**

---

### 5.4 — Remover credenciais antigas do Windows Credential Manager

Para evitar conflitos com a nova chave SSH ou tokens:

1. Abra **Painel de Controle → Contas de Usuário → Gerenciador de Credenciais → Credenciais do Windows**
2. Localize entradas relacionadas ao Git e GitHub
3. Clique em **Remover** ou **Excluir**
4. Reinicie o **VSCode** ou terminal **WSL** antes de usar o Git novamente

> Ao usar Git novamente, você poderá gerar ou autenticar com a nova chave SSH sem problemas.

---

## ✔ 6. Boas práticas no WSL

| Ação                                                        | Local recomendado                    |
| ------------------------------------------------------------|--------------------------------------|
| Clonar repositórios                                         | `/home/<user>/<projects-folder>/...` |
| Instalar dependências Python ou de qualquer outra linguagem | Dentro do WSL                        |
| Rodar containers Docker/Podman                              | Dentro do WSL                        |
| Evitar caminhos do tipo `C:\Users\...`                      | ❌ Desempenho ruim                   |

---

## 💻 7. Usar o VSCode com o WSL

> Evitar o acesso a arquivos que estejam no Windows (`/mnt/c/...`) é **muito mais lento**, pois ocorre via rede.

### 7.1 — Instalar a extensão “WSL”

1. Abra o VSCode
2. Vá em `Extensões (Ctrl+Shift+X)`
3. Busque: **WSL**
4. Instale a extensão oficial da Microsoft

---

### 7.2 — Abrir projetos dentro do Linux

No terminal do WSL:

```bash
cd ~/projects/meu-projeto
code .
```

Ou

```bash
cd ~/projects
code meu-projeto
```

---

## 🐍 8. Instalação do pyenv

O pyenv permite gerenciar múltiplas versões do Python no Linux.

### 8.1 — Atualizar pacotes

```bash
sudo apt update && sudo apt upgrade -y
```

### 8.2 — Instalar dependências necessárias

```bash
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
liblzma-dev git
```

### 8.3 — Instalar o pyenv

```bash
curl https://pyenv.run | bash
```

### 8.4 — Configurar o shell

Adicione as seguintes linhas ao final do arquivo `~/.bashrc`:

```bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

Recarregue o shell:

```bash
exec "$SHELL"
```

### 8.5 — Instalar e definir uma versão do Python

```bash
pyenv install 3.13.12
pyenv global 3.13.12
python --version
```

---

## 🟩 9. Instalação do NVM

O **NVM** **(Node Version Manager)** permite instalar e gerenciar múltiplas versões do **Node.js** dentro do WSL, sem interferir no sistema.
Ideal para desenvolvimento com **Node**, **React**, **Next.js**, **NestJS**, entre outros frameworks.

---

### 9.1 — Atualizar pacotes

```bash
sudo apt update && sudo apt upgrade -y
```

---

### 9.2 — Instalar o NVM

Baixe e execute o script oficial de instalação:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

> 🔸 **Dica:** sempre use a versão estável mais recente do repositório oficial
> 👉 [https://github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm)

---

### 9.3 — Ativar o NVM no shell

Adicione as seguintes linhas ao final do seu `~/.bashrc`, caso o instalador ainda não as tenha adicionado automaticamente:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

Recarregue o shell:

```bash
exec "$SHELL"
```

---

### 9.4 — Verificar instalação

```bash
nvm --version
```

Se aparecer o número da versão, o NVM foi instalado corretamente ✅

---

### 9.5 — Instalar uma versão específica do Node.js

Exemplo: instalar a versão LTS atual

```bash
nvm install --lts
```

Definir como padrão:

```bash
nvm alias default lts/*
```

Verificar:

```bash
node -v
npm -v
```

---

### 9.6 — Usar múltiplas versões

Você pode alternar entre versões facilmente:

```bash
nvm install 20
nvm install 18
nvm use 18
```

> Isso é útil quando diferentes projetos exigem versões diferentes do Node.js.

---

### ⚙️ 9.7 — Boas práticas

* Sempre use `nvm install` em vez de `sudo apt install nodejs`
* Evite instalar Node.js globalmente no sistema

---

## 🐳 10. Instalação do Docker Engine

O **Docker Engine** permite executar containers Linux diretamente dentro do WSL, sem precisar do Docker Desktop.
Essa instalação é ideal para quem quer um ambiente 100% Linux, leve e isolado.

---

### 10.1 — Atualizar pacotes e instalar dependências

```bash
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release -y
```

---

### 10.2 — Adicionar chave GPG oficial do Docker

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

---

### 10.3 — Adicionar o repositório do Docker

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

### 10.4 — Instalar o Docker Engine

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

---

### 10.5 — Adicionar seu usuário ao grupo `docker`

```bash
sudo usermod -aG docker $USER
```

Recarregue o shell:

```bash
exec "$SHELL"
```

---

### 10.6 — Testar a instalação

```bash
docker version
docker run hello-world
```

Se o comando acima exibir a mensagem “Hello from Docker!”, a instalação foi concluída com sucesso. 🚀

---

## ☸️ 11. Instalação do Minikube, Kubectl e k9s

O **Minikube** permite executar clusters Kubernetes localmente para desenvolvimento e testes.
O **kubectl** é o cliente de linha de comando para interagir com clusters Kubernetes.
O **K9s** é uma interface de terminal interativa para gerenciar clusters Kubernetes de forma visual e eficiente.

---

### 11.1 — Atualizar pacotes

```bash
sudo apt update && sudo apt upgrade -y
```

---

### 11.2 — Instalar o Minikube

Baixe a versão mais recente do Minikube para Linux:

```bash
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
```

Instale o binário no diretório do sistema:

```bash
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

---

### 11.3 — Instalar o kubectl

Baixe a versão mais recente do kubectl:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Instale o binário no diretório do sistema:

```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl
```

---

### 11.4 — Instalar o K9s

Baixe o executável compactado:

> 🔸 **Nota:** Substitua `v0.50.18` pela versão desejada. Verifique as versões disponíveis em [https://github.com/derailed/k9s/releases](https://github.com/derailed/k9s/releases)

```bash
wget https://github.com/derailed/k9s/releases/download/v0.50.18/k9s_Linux_amd64.tar.gz -O /tmp/k9s.tar.gz
```

Extraia o executável:

```bash
tar -zxvf /tmp/k9s.tar.gz --directory /tmp/
```

Dê permissão de execução:

```bash
chmod +x /tmp/k9s
```

Mova o executável para o PATH do sistema:

```bash
sudo mv /tmp/k9s /usr/local/bin/k9s
```

Remova o arquivo temporário:

```bash
rm /tmp/k9s.tar.gz
```

---

### 11.5 — Verificar instalação

```bash
minikube version
kubectl version --client
k9s version
```

Se os comandos acima exibirem as versões instaladas, a instalação foi concluída com sucesso ✅

---

## 🚀 12. Instalação do goenv

O **goenv** permite gerenciar múltiplas versões do **Go** no Linux, facilitando a configuração por projeto e a troca entre versões.

---

### 12.1 — Instalar dependências

Abra o terminal e execute:

```bash
sudo apt update
sudo apt install -y git curl build-essential
```

---

### 12.2 — Instalar o goenv

Clone o repositório oficial do **goenv**:

```bash
git clone https://github.com/syndbg/goenv.git ~/.goenv
```

---

### 12.3 — Configurar variáveis de ambiente

Adicione ao final do seu `~/.bashrc`

```bash
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
```

Depois, recarregue o shell:

```bash
source ~/.bashrc
```

---

### 12.4 — Verificar instalação

```bash
goenv --version
```

Se aparecer a versão, está instalado corretamente ✅

---

### 12.5 — Instalar uma versão do Go

Liste as versões disponíveis:

```bash
goenv install -l
```

Instale uma versão específica (exemplo):

```bash
goenv install 1.22.0
```

Defina como global:

```bash
goenv global 1.22.0
```

Verifique:

```bash
go version
```

---

## ⚡ 13. Instalação do UV

O **UV** é um gerenciador de pacotes e ambientes Python extremamente rápido, escrito em Rust.

---

### 13.1 — Instalar o UV

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Adicione ao `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Depois, recarregue o shell:

```bash
source ~/.bashrc
```

---

### 13.2 — Verificar instalação

```bash
uv --version
```

---

### 13.3 — Criar projeto

Crie a pasta do projeto:
```bash
mkdir <project-name>
```

Entre na pasta:
```bash
cd <project-name>
```

Inicialize o projeto:
```bash
uv init
```

---

### 13.4 — Criar ambiente virtual
```bash
uv venv
```

---

### 13.5 — Instalar dependências

```bash
uv add <lib-name>
```

---

### 13.6 — Executar script dentro do ambiente

```bash
uv run main.py
```
