# 🐧 Guia Completo: Instalação e Uso do WSL no Windows

Este guia explica como **remover instalações antigas do WSL**, configurar um ambiente novo, instalar o **pyenv** e usar o **VSCode** de forma otimizada dentro do Linux.

## 📋 Sumário

0. [🧹 (Opcional) Remover instalação antiga do WSL](#-0-opcional-remover-instalação-antiga-do-wsl)
1. [🧩 Habilitar recursos do Windows](#-1-habilitar-os-recursos-necessários-do-windows)
2. [🐧 Instalar e configurar o WSL](#-2-instalar-e-configurar-o-wsl)
3. [🧱 Acessar o terminal Linux](#-3-acessar-o-terminal-linux)
4. [🐍 Instalar o pyenv no WSL](#-4-instalar-o-pyenv-no-wsl-ubuntu)
5. [💻 Usar o VSCode com o WSL](#-5-usando-o-vscode-com-o-wsl)
6. [⚡ Boas práticas no WSL](#-6-boas-práticas-no-wsl)
7. [🧰 Configuração do Git](#-7-configuração-do-git)
8. [🗝️ Configuração de SSH](#️-8-configuração-de-ssh)
9. [🐳 (Opcional) Instalar Docker Engine no WSL](#-9-opcional-instalação-do-docker-engine-no-wsl)
10. [🟩 (Opcional) Instalar e configurar o NVM](#-10-opcional-instalação-e-configuração-do-nvm-node-version-manager)

---

## 🧹 0. (Opcional) Remover instalação antiga do WSL

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

---

## 🐍 4. Instalar o `pyenv` no WSL (Ubuntu)

O `pyenv` permite gerenciar múltiplas versões do Python no Linux.

### 4.1 — Atualizar pacotes

```bash
sudo apt update && sudo apt upgrade -y
```

### 4.2 — Instalar dependências necessárias

```bash
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
liblzma-dev git
```

### 4.3 — Instalar o `pyenv`

```bash
curl https://pyenv.run | bash
```

### 4.4 — Configurar o shell

Adicione as seguintes linhas ao final do arquivo `~/.bashrc` (ou `~/.zshrc`, se usar Zsh):

```bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

Recarregue o shell:

```bash
exec "$SHELL"
```

### 4.5 — Instalar e definir uma versão do Python

```bash
pyenv install 3.12.7
pyenv global 3.12.7
python --version
```

---

## 💻 5. Usando o VSCode com o WSL

> ⚠️ **Importante:** Para máximo desempenho, mantenha **todos os projetos dentro do Linux**, por exemplo:
>
> ```
> /home/<user>/<projects_folder>/
> ```
>
> O acesso a arquivos pelo Windows (`/mnt/c/...`) é **muito mais lento**, pois ocorre via rede.

---

### 5.1 — Instalar a extensão “Remote - WSL”

1. Abra o VSCode
2. Vá em `Extensões (Ctrl+Shift+X)`
3. Busque: **Remote - WSL**
4. Instale a extensão oficial da Microsoft

---

### 5.2 — Abrir projetos dentro do Linux

No terminal do WSL:

```bash
cd ~/projects/meu-projeto
code .
```

---

## ⚡ 6. Boas práticas no WSL

| Ação                                   | Local recomendado                |
| -------------------------------------- | -------------------------------- |
| Clonar repositórios                    | `/home/<user>/<projects_folder>/...` |
| Instalar dependências Python           | Dentro do WSL                    |
| Rodar containers Docker/Podman         | Dentro do WSL                    |
| Evitar caminhos do tipo `C:\Users\...` | ❌ Desempenho ruim                |
| Fazer backup de código                 | Via Git, não manualmente do VHDX |

---

## 🧰 7. Configuração do Git

Após instalar o Git (ele já vem com o Ubuntu, mas pode ser atualizado), configure suas credenciais e cache de autenticação.

### 7.1 — Verifique se o Git está instalado

```bash
git --version
```

Se precisar instalar:

```bash
sudo apt install git -y
```

---

### 7.2 — Configure o nome e e-mail globais

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

### 7.3 — Habilitar o **Credential Manager**

Isso permite salvar tokens de acesso do GitHub, Azure DevOps, Bitbucket etc., de forma segura.

#### Passo 1 — Instalar o pacote auxiliar

```bash
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

> Isso usa o **Git Credential Manager (GCM)**, que já vem integrado no Git para Windows e é compatível com WSL.

---

## 🗝️ 8. Configuração de SSH

Para autenticação segura com GitHub, utilize **chaves SSH**.

### 8.1 — Seguir o passo a passo oficial fornecido pela empresa

> Siga exatamente as instruções fornecidas no guia para criar e registrar sua chave SSH.

---

### 8.2 — Remover credenciais antigas do Windows Credential Manager

Para evitar conflitos com a nova chave SSH ou tokens:

1. Abra **Painel de Controle → Contas de Usuário → Gerenciador de Credenciais → Credenciais do Windows**
2. Localize entradas relacionadas ao Git e GitHub
3. Clique em **Remover** ou **Excluir**
4. Reinicie o **VSCode** ou terminal **WSL** antes de usar o Git novamente

> Ao usar Git novamente, você poderá gerar ou autenticar com a nova chave SSH sem problemas.

---

## 🐳 9. (Opcional) Instalação do Docker Engine no WSL

O **Docker Engine** permite executar containers Linux diretamente dentro do WSL, sem precisar do Docker Desktop.
Essa instalação é ideal para quem quer um ambiente 100% Linux, leve e isolado.

---

### 9.1 — Atualizar pacotes e instalar dependências

```bash
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release -y
```

---

### 9.2 — Adicionar chave GPG oficial do Docker

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

---

### 9.3 — Adicionar o repositório do Docker

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

### 9.4 — Instalar o Docker Engine

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

---

### 9.5 — Adicionar seu usuário ao grupo `docker`

```bash
sudo usermod -aG docker $USER
```

Recarregue o shell:

```bash
exec "$SHELL"
```

---

### 9.6 — Testar a instalação

```bash
docker version
docker run hello-world
```

Se o comando acima exibir a mensagem “Hello from Docker!”, a instalação foi concluída com sucesso. 🚀

---

## 🟩 10. (Opcional) Instalação e configuração do NVM (Node Version Manager)

O **NVM** permite instalar e gerenciar múltiplas versões do **Node.js** dentro do WSL, sem interferir no sistema.
Ideal para desenvolvimento com **Node**, **React**, **Next.js**, **NestJS**, entre outros frameworks.

---

### 10.1 — Atualizar pacotes

```bash
sudo apt update && sudo apt upgrade -y
```

---

### 10.2 — Instalar o NVM

Baixe e execute o script oficial de instalação:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

> 🔸 **Dica:** sempre use a versão estável mais recente do repositório oficial
> 👉 [https://github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm)

---

### 10.3 — Ativar o NVM no shell

Adicione as seguintes linhas ao final do seu `~/.bashrc` (se o instalador ainda não adicionou automaticamente):

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

Recarregue o shell:

```bash
exec "$SHELL"
```

---

### 10.4 — Verificar instalação

```bash
nvm --version
```

Se aparecer o número da versão, o NVM foi instalado corretamente ✅

---

### 10.5 — Instalar uma versão específica do Node.js

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

### 10.6 — Usar múltiplas versões

Você pode alternar entre versões facilmente:

```bash
nvm install 20
nvm install 18
nvm use 18
```

> Isso é útil quando diferentes projetos exigem versões diferentes do Node.js.

---

### ⚙️ 10.7 — Boas práticas

* Sempre use `nvm install` em vez de `sudo apt install nodejs`
* Evite instalar Node.js globalmente no sistema
