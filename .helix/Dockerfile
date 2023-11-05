FROM debian:bookworm-slim

ARG DOCKERFILE_LANGUAGE_SERVER_NODEJS_VERSION="0.11.0" 
ARG GITUI_TAR="gitui-linux-musl.tar.gz"
ARG GITUI_VERSION="v0.24.3"
ARG GO_DELVE_VERSION="v1.21.2"
ARG GOPLS_VERSION="v0.14.1"
ARG GO_VERSION="1.21.3"
ARG GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
ARG HELIX_VERSION="23.10"
ARG HELIX_TAR="helix-${HELIX_VERSION}-x86_64-linux.tar.xz"
ARG MARKSMAN_VERSION="2023-10-30"
ARG NODE_VERSION="21.1.0"
ARG NVM_VERSION="v0.39.5"
ARG PRETTIER_VERSION="3.0.3"
ARG PYENV_GIT_TAG="v2.3.31"
ARG PYTHON_VERSION="3.11.2"
ARG TAPLO_VERSION="0.8.1"
ARG WORKSPACE="workspace"
ARG YAML_LANGUAGE_SERVER_VERSION="1.14.0"
ARG ZELLIJ_VERSION="v0.38.2"
ARG ZELLIJ_TAR="zellij-x86_64-unknown-linux-musl.tar.gz"

SHELL ["/bin/bash", "--login", "-c"]

# SYSTEM UPDATE
RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y \
  curl \
  build-essential \
  git \
  libffi-dev \
  libssl-dev \
  python3-dev \
  python3-pip \
  python3-venv \
  tree \
  xclip \
  xsel

# INSTALL PYTHON
RUN curl https://pyenv.run | bash && \
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc

RUN pyenv install $PYTHON_VERSION

# INSTALL NODE
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

RUN nvm install ${NODE_VERSION} && \
  nvm use ${NODE_VERSION}

# INSTALL GO
RUN curl -fsSL https://go.dev/dl/${GO_TAR} --output ${GO_TAR} && \
  rm -rf /usr/local/go && \
  tar -C /usr/local -xzf ${GO_TAR} && \
  echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc

# INSTALL ZELLIJ
RUN curl -fsSL https://github.com/zellij-org/zellij/releases/download/${ZELLIJ_VERSION}/${ZELLIJ_TAR} --output ${ZELLIJ_TAR} && \
  tar -xvf ${ZELLIJ_TAR} && \
  chmod +x zellij && \
  mv zellij /usr/local/bin && \
  rm ${ZELLIJ_TAR}

# INSTALL HELIX
RUN curl -fsSL https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/${HELIX_TAR} --output ${HELIX_TAR} && \
  tar -xvf ${HELIX_TAR} && \
  mv helix-${HELIX_VERSION}-x86_64-linux/hx /usr/local/bin && \
  mkdir -p /root/.config/helix && \
  cp -r helix-${HELIX_VERSION}-x86_64-linux/runtime $HOME/.config/helix/ && \
  rm ${HELIX_TAR}

RUN hx --grammar fetch && \
  hx --grammar build

# INSTALL HELIX LSP PROVIDERS AND HELPERS
RUN npm install --global \
  dockerfile-language-server-nodejs@${DOCKERFILE_LANGUAGE_SERVER_NODEJS_VERSION} \
  prettier@${PRETTIER_VERSION} \
  yaml-language-server@${YAML_LANGUAGE_SERVER_VERSION}

RUN curl -fsSL https://github.com/tamasfe/taplo/releases/download/${TAPLO_VERSION}/taplo-full-linux-x86_64.gz | gzip -d - | install -m 755 /dev/stdin /usr/local/bin/taplo

RUN curl -fsSL https://github.com/artempyanykh/marksman/releases/download/${MARKSMAN_VERSION}/marksman-linux-x64 --output marksman && \
  chmod +x marksman && \
  mv marksman /usr/local/bin

RUN go install golang.org/x/tools/gopls@${GOPLS_VERSION} && \
  go install github.com/go-delve/delve/cmd/dlv@${GO_DELVE_VERSION}

# INSTALL GITUI
RUN curl -fsSL https://github.com/extrawurst/gitui/releases/download/${GITUI_VERSION}/${GITUI_TAR} --output ${GITUI_TAR} && \
  tar -xvf ${GITUI_TAR} && \
  mv gitui /usr/local/bin && \
  rm ${GITUI_TAR}

COPY ./requirements.lsp.txt /root
RUN pip3 install -r /root/requirements.lsp.txt --break-system-packages

# SETUP WORK ENV
COPY .bashrc /root/.bashrc

WORKDIR /workspaces/${WORKSPACE}

ENV SHELL=/bin/bash
ENTRYPOINT ["zellij"]
CMD [ "options","--copy-command=xclip -selection clipboard"]

