# syntax=docker/dockerfile:1

ARG VARIANT="20"
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-${VARIANT}

# Install some generally useful tools
RUN apt-get update && apt-get -y install --no-install-recommends curl git
# Install SAP CAP SDK globally
USER node
RUN npm install -g @sap/cds-dk
WORKDIR /home/node

# Install SAP Machine
RUN wget -qO- https://dist.sapmachine.io/debian/sapmachine.key | sudo tee /etc/apt/trusted.gpg.d/sapmachine.asc > /dev/null
RUN echo "deb https://dist.sapmachine.io/debian/arm64/ ./" | sudo tee /etc/apt/sources.list.d/sapmachine.list > /dev/null
RUN sudo apt-get update
RUN sudo apt-get install sapmachine-21-jdk -y

ENV JAVA_HOME /usr/lib/jvm/sapmachine-21/

# RUN sudo apt-get update && apt-get -y install --no-install-recommends sapmachine-21-jdk

# Install Open JDK
# RUN sudo apt-get -y install openjdk-21-jdk