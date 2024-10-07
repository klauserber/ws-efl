FROM ubuntu:24.04

ARG TARGETARCH
ARG TARGETOS=linux

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin" apt-get install -y \
    ca-certificates \
    software-properties-common \
    curl \
    wget \
    gnupg \
    python3 \
    python3-pip \
    python3-venv \
    python3-dnspython \
    python3-boto3 \
    python3-google-auth \
    python3-hcloud \
    python3-openshift \
    python3-passlib \
    unzip \
    zip \
    iputils-ping \
    sudo \
    git \
    vim \
    jq \
    ssh \
    pkg-config \
    dnsutils \
    iproute2 \
    rsync \
    s3cmd \
    pwgen \
    git-crypt \
    jq \
    gettext-base \
    bash-completion \
    sipcalc \
    restic \
    tini \
    netcat-openbsd \
    zsh && \
  add-apt-repository --yes --update ppa:ansible/ansible && \
  apt install -y \
    ansible-core \
    ansible-lint \
 && rm -rf /var/lib/apt/lists/*

# ##version: https://hub.docker.com/_/docker/tags
COPY --from=docker:27.3.1-cli /usr/local/bin/docker /usr/local/bin/docker-compose /usr/local/bin/
RUN curl -s https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh

# ##versions: https://hub.docker.com/r/docker/buildx-bin/tags
COPY --from=docker/buildx-bin:0.17.1 /buildx /usr/libexec/docker/cli-plugins/docker-buildx

# RUN set -e; \
#   ansible-galaxy install -p /usr/share/ansible/collections -r /tmp/ansible-requirements.yml; \
#   rm /tmp/requirements.txt /tmp/ansible-requirements.yml


# ##versions: https://github.com/helm/helm/releases
ARG HELM_VERSION=3.16.1
RUN set -e; \
  cd /tmp; \
  curl -Ss -o helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz; \
  tar xzf helm.tar.gz; \
  mv ${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/; \
  chmod +x /usr/local/bin/helm; \
  rm -rf ${TARGETOS}-${TARGETARCH} helm.tar.gz

# ##versions: https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=1.31.1
RUN set -e; \
    cd /tmp; \
    curl -sLO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl"; \
    mv kubectl /usr/local/bin/; \
    chmod +x /usr/local/bin/kubectl

# Install awscli current version
# RUN set -e; \
#   cd /tmp; \
#   curl -LSs -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip; \
#   unzip awscliv2.zip; \
#   ./aws/install; \
#   rm -rf ./aws awscliv2.zip;

# https://cloud.google.com/sdk/docs/release-notes
# ARG GCLOUD_CLI_VERSION=494.0.0
# RUN set -e; \
#   if [ "${TARGETARCH}" = "amd64" ]; then TARGETARCH="x86_64"; fi; \
#   if [ "${TARGETARCH}" = "arm64" ]; then TARGETARCH="arm"; fi; \
#   curl -sSL -o /tmp/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_CLI_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz; \
#   tar -C /usr/local -xzf /tmp/google-cloud-sdk.tar.gz; \
#   rm /tmp/google-cloud-sdk.tar.gz; \
#   /usr/local/google-cloud-sdk/install.sh --quiet; \
#   /usr/local/google-cloud-sdk/bin/gcloud components install gke-gcloud-auth-plugin --quiet

# ##versions: https://github.com/doitintl/kube-no-trouble/releases
ARG KUBENT_VERSION=0.7.3
RUN set -e; \
  mkdir -p /tmp/kubent; \
  cd /tmp/kubent; \
  curl -LSs -o kubent.tar.gz https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz; \
  tar xzf kubent.tar.gz; \
  mv kubent /usr/local/bin/; \
  cd /tmp; \
  rm -rf kubent

# ##versions: https://github.com/hashicorp/terraform/releases
ARG TERRAFORM_VERSION=1.5.7
RUN set -e; \
  cd /tmp; \
  curl -Ss -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip; \
  unzip terraform.zip; \
  mv terraform /usr/local/bin/; \
  chmod +x /usr/local/bin/terraform; \
  rm terraform.zip

# ##versions: https://github.com/opentofu/opentofu/releases
ARG TOFU_VERSION=1.8.3
RUN set -e; \
  cd /tmp; \
  curl -LSs -o tofu.tar.gz https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz; \
  tar xf tofu.tar.gz -C /usr/local/bin/; \
  rm ./tofu.tar.gz

  # install azure-cli current version
# RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# # ##versions: https://github.com/bitnami-labs/sealed-secrets/releases
# ARG KUBESEAL_VERSION=0.27.1
# RUN set -e; \
#   cd /tmp; \
#   wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz; \
#   tar -xzf kubeseal-${KUBESEAL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz kubeseal; \
#   install -m 755 kubeseal /usr/local/bin/kubeseal; \
#   rm -rf kubeseal-${KUBESEAL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz kubeseal

# https://github.com/fluxcd/flux2/releases
# ARG FLUX_VERSION=2.1.2
# RUN set -e; \
#   cd /tmp; \
#   wget https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz; \
#   tar -xzf flux_${FLUX_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz; \
#   install -m 755 flux /usr/local/bin/flux; \
#   rm -rf flux_${FLUX_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz flux

COPY bin/* /usr/local/bin/

RUN userdel -r ubuntu && \
    useradd coder \
      --create-home \
      --shell=/bin/bash \
      --uid=1000 \
      --user-group && \
      echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd && \
      usermod -aG root coder

RUN mkdir -p /pyenv && chown coder:coder /pyenv

USER coder

COPY requirements.txt /pyenv/
RUN python3 -m venv /pyenv && \
    . /pyenv/bin/activate && \
    pip3 install -r /pyenv/requirements.txt -i https://mirrors.sustech.edu.cn/pypi/web/simple

ENV PATH=${PATH}:/home/coder/.local/bin:/home/coder/bin

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=en_US:en

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]