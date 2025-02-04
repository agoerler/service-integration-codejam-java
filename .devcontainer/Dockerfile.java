# syntax=docker/dockerfile:1

ARG VARIANT="20"
FROM mcr.microsoft.com/vscode/devcontainers/java:21

# Install some generally useful tools
RUN apt-get update && apt-get -y install --no-install-recommends curl git

# Install Node.js
RUN apt-get update && apt-get -y install --no-install-recommends software-properties-common npm
#RUN npm install npm@latest -g
RUN npm install n -g
RUN n lts
# RUN apt-get update && apt-get install -y \
#     software-properties-common \
#     npm
# RUN npm install npm@lts -g && \
#     npm install n -g && \
#     n lts

# Install SAP CAP SDK globally
#USER node
#RUN npm install -g @sap/cds-dk
#WORKDIR /home/node

