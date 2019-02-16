FROM rdissertori/jenkins-slave

ENV KOTLIN_VERSION "v1.3.21"
ENV KOTLIN_DOWNLOADURL "https://github.com/JetBrains/kotlin/releases/download/v1.3.21/experimental-kotlin-compiler-linux-x64.zip"
ENV ANDROID_SDK_VERSION "4333796"
ENV ANDROID_SDK_DOWNLOADURL "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"

ENV KOTLIN_HOME /opt/kotlin
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH ${PATH}:${KOTLIN_HOME}/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin

USER root
COPY /install.sh /tmp/install.sh
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
&& sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
&& wget -q https://packages.microsoft.com/config/debian/9/prod.list \
&& mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
&& chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
&& chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
&& AZ_REPO=$(lsb_release -cs)
&& echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
&& sudo tee /etc/apt/sources.list.d/azure-cli.list
&& apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
&& --keyserver packages.microsoft.com \
&& --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF
&& apt-get update -qqy \
&& apt-get install --fix-missing \
&& apt-get install -y --no-install-recommends apt-transport-https lsb-release software-properties-common dirmngr \
&& apt-get install -y dotnet-sdk-2.2 powershell azure-cli
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /tmp/* \
&& chown -R jenkins:jenkins /home/jenkins
USER jenkins
