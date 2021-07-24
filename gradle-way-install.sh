#!/bin/bash

# Attention! It's Ubuntu-specific!

#curl -s "https://get.sdkman.io" | bash 

#source ~/.bashrc
#sdk install gradle

# https://yallalabs.com/devops/how-to-install-gradle-ubuntu-18-04-ubuntu-16-04/
# Пока на всякий случай. Пытаюсь решить проблему в обход gradle.

sudo apt install openjdk-8-jdk
wget https://services.gradle.org/distributions/gradle-6.4.1-bin.zip -P /tmp
sudo unzip -d /opt/gradle /tmp/gradle-*.zip

sudo vi /etc/profile.d/gradle.sh:
	export GRADLE_HOME=/opt/gradle/gradle-6.4.1
	export PATH=${GRADLE_HOME}/bin:${PATH}

source /etc/profile.d/gradle.sh


gradle -v
