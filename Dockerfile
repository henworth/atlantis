FROM runatlantis/atlantis:v0.17.4

ENV TERRAFORM_VERSION=1.0.6
ENV TERRAGRUNT_VERSION=0.34.1
ENV TERRAGRUNT_ATLANTIS_VERSION=1.9.2
ENV TERRAGRUNT_ATLANTIS_FILENAME="terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64"

WORKDIR /tmp

ENV PATH "/home/atlantis/.tgenv/bin:/home/atlantis/.tfenv/bin:${PATH}"

RUN curl -L -s --output "${TERRAGRUNT_ATLANTIS_FILENAME}.tar.gz" "https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_VERSION}/${TERRAGRUNT_ATLANTIS_FILENAME}.tar.gz" && \
    tar xf "${TERRAGRUNT_ATLANTIS_FILENAME}.tar.gz" && \
    mv "${TERRAGRUNT_ATLANTIS_FILENAME}/${TERRAGRUNT_ATLANTIS_FILENAME}" /usr/local/bin/terragrunt-atlantis-config && \
    chmod +x /usr/local/bin/terragrunt-atlantis-config && \
    git clone https://github.com/tfutils/tfenv.git /home/atlantis/.tfenv && \
    git clone https://github.com/cunymatthieu/tgenv.git /home/atlantis/.tgenv && \
    echo "export PATH=/home/atlantis/.tgenv/bin:/home/atlantis/.tfenv/bin:${PATH}" >> /home/atlantis/.bashrc && \
    chown -R atlantis:atlantis /home/atlantis && \
    rm -rf "${TERRAGRUNT_ATLANTIS_FILENAME}.tar.gz" "${TERRAGRUNT_ATLANTIS_FILENAME}" && \
    /home/atlantis/.tfenv/bin/tfenv install $TERRAFORM_VERSION && \
    /home/atlantis/.tfenv/bin/tfenv use $TERRAFORM_VERSION && \
    /home/atlantis/.tgenv/bin/tgenv install $TERRAGRUNT_VERSION && \
    /home/atlantis/.tgenv/bin/tgenv use $TERRAGRUNT_VERSION
