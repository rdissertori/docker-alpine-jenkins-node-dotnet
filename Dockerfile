FROM rdissertori/alpine-jenkins-node-base

ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

USER root
RUN apk add --update --no-cache icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib \
ca-certificates less ncurses-terminfo-base tzdata userspace-rcu curl \
python3 libffi openssl \
&& rm -rf /tmp/* \
&& chown -R jenkins:jenkins /home/jenkins
# dotnet sdk
ADD https://dot.net/v1/dotnet-install.sh /root/
RUN chmod +x ./dotnet-install.sh && sh ./dotnet-install.sh -c Current
# powershell
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust \
&& curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.0.3/powershell-7.0.3-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz \
&& mkdir -p /opt/microsoft/powershell/7 \
&& tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
&& chmod +x /opt/microsoft/powershell/7/pwsh \
&& ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
# azure cli
RUN curl -L https://aka.ms/InstallAzureCli | bash
USER jenkins
