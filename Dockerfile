FROM runatlantis/atlantis:v0.17.6

ENV TERRAFORM_VERSION=1.0.11
ENV TERRAGRUNT_VERSION=0.35.13

ENV TERRAGRUNT_ATLANTIS_VERSION=1.12.1
ENV TERRAGRUNT_ATLANTIS_FILENAME="terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64"

WORKDIR /tmp

RUN apk add --update --no-cache nodejs npm libc6-compat

RUN curl -L -s --output "${TERRAGRUNT_ATLANTIS_FILENAME}.tar.gz" "https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_VERSION}/${TERRAGRUNT_ATLANTIS_FILENAME}.tar.gz" && \
    tar xf "${TERRAGRUNT_ATLANTIS_FILENAME}.tar.gz" && \
    mv "${TERRAGRUNT_ATLANTIS_FILENAME}/${TERRAGRUNT_ATLANTIS_FILENAME}" /usr/local/bin/terragrunt-atlantis-config && \
    chmod +x /usr/local/bin/terragrunt-atlantis-config

RUN npm install shelljs path && \
    curl -L -s --output /home/atlantis/terragrunt_light.js https://gist.githubusercontent.com/dmattia/0d17696bad1dffd90ec7c899e0343955/raw/9ab0cb7fef04327442436679496e11990b6fc2d8/terragrunt_light.js && \
    chown atlantis:atlantis /home/atlantis/terragrunt_light.js

RUN git clone https://github.com/tfutils/tfenv.git /home/atlantis/.tfenv && \
    git clone https://github.com/taosmountain/tgenv.git /tmp/tgenv && \
    cd /tmp/tgenv && git pull --rebase origin pull/1/head && cd /tmp && mv /tmp/tgenv /home/atlantis/.tgenv && \
    echo "export PATH=/home/atlantis/.tgenv/bin:/home/atlantis/.tfenv/bin:${PATH}" >> /home/atlantis/.bashrc && \
    /home/atlantis/.tfenv/bin/tfenv install $TERRAFORM_VERSION && \
    /home/atlantis/.tfenv/bin/tfenv use $TERRAFORM_VERSION && \
    /home/atlantis/.tgenv/bin/tgenv install $TERRAGRUNT_VERSION && \
    /home/atlantis/.tgenv/bin/tgenv use $TERRAGRUNT_VERSION && \
    chown -R atlantis:atlantis /home/atlantis

RUN rm -rf /tmp/*
