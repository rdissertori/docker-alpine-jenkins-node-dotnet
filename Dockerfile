FROM rdissertori/jenkins-slave

USER root
COPY /install.sh /tmp/install.sh
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
&& mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
&& wget -q https://packages.microsoft.com/config/debian/9/prod.list \
&& mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
&& chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
&& chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
&& AZ_REPO=$(lsb_release -cs) \
&& echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
tee /etc/apt/sources.list.d/azure-cli.list \
&& apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
--keyserver packages.microsoft.com \
--recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF \
&& apt-get update -qqy \
&& apt-get install --fix-missing \
&& apt-get install -y --no-install-recommends apt-transport-https lsb-release software-properties-common dirmngr \
&& apt-get install -y dotnet-sdk-2.2 powershell azure-cli \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /tmp/* \
&& chown -R jenkins:jenkins /home/jenkins
USER jenkins
