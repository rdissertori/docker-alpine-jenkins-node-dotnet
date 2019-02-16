FROM rdissertori/jenkins-slave

ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

USER root
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
  && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
  && curl -s https://packages.microsoft.com/config/debian/9/prod.list -o prod.list \
  && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
  && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
  && chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > /etc/apt/sources.list.d/azure-cli.list \
  && apt-get update -qqy \
  && apt-get install --fix-missing \
  && apt-get install -y --no-install-recommends apt-transport-https lsb-release software-properties-common dirmngr \
  && apt-get install -y dotnet-sdk-2.2 powershell azure-cli \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && chown -R jenkins:jenkins /home/jenkins
USER jenkins
