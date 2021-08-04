#!/bin/bash
#http://www.hanshq.net/command-line-android.html

VERSIONS=(
    # comment
        # откуда берём JDK (способ получения: user_provide|download_and_untar|download_and_unzip|apt_install)
            # имя пакета JDK
                # откуда берём sdk-tools (способ получения| user_provide|download_and_untar|download_and_unzip|apt_install)
    "Android 5.1.1 (API level 22); "
        user_provide
            jdk-9.0.1_linux-x64_bin.tar.gz
    "Android 7.0 (API level 24a; )"
        user_provide
            
)

#JDK_FILE=jdk-9.0.1_linux-x64_bin.tar.gz

RED='\033[0;31m'
YEL='\033[1;33m'
NC='\033[0m'

mkdir environments
echo 'JAVA_HOME=${MYANDROID}/java-se-9-ri/jdk-9
PATH=${JAVA_HOME}/bin:$PATH
SDK="${MYANDROID}"/android-sdk-linux
BUILD_TOOLS="${SDK}"/build-tools/27.0.1
PLATFORM="${SDK}"/platforms/android-22
PATH="$SDK"/platform-tools:"$SDK"/build-tools/27.0.1:"$SDK":"$PATH"
BUILD_TARGET_DESCRIPTION="Android 5.1.1 (API level 22)"
' > environments/1

echo -e "${YEL}Скачиваю и распаковываю JDK-9${NC}"
wget https://download.java.net/openjdk/jdk9/ri/openjdk-9+181_linux-x64_ri.zip &&
    unzip openjdk-9+181_linux-x64_ri.zip &&
    rm openjdk-9+181_linux-x64_ri.zip || (echo "can not download and prepare jdk9";exit 1)


echo -e "${YEL}Скачиваю и распаковываю sdk-tools${NC}"
wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
unzip sdk-tools-linux-3859397.zip

echo -e "${YEL}Скачиваю и распаковываю build-tools${NC}"
wget https://dl.google.com/android/repository/build-tools_r27.0.1-linux.zip # api v.27 (Android 8.1)
unzip build-tools_r27.0.1-linux.zip
mkdir tools/build-tools
mv android-8.1.0 tools/build-tools/27.0.1

echo -e "${YEL}Скачиваю и распаковываю ndk${NC}"
wget https://dl.google.com/android/repository/android-ndk-r16-linux-x86_64.zip
unzip android-ndk-r16-linux-x86_64.zip

# Запускаем android-studio. Открываем SDK Manager. Appearance&Behaviour -> System Settings --> Android SDK.
# Вкладка SDK Update Sites. По этому адресу можно увидеть XML с перечнем доступных платформ. Выбираем, подменяем в адресе на указанный в XML android-xxxx.zip и скачиваем
# По состоянию на март 2018 года самый свежий - https://dl.google.com/android/repository/repository2-1.xml
# Для разработки в студии и сборки вручную я брал (мог бы взять, кабы не старая версия андроида на моём устройстве) https://dl.google.com/android/repository/platform-26_r02.zip
# Для того, чтобы в студии можно было разрабатывать под моё (старое) устройство, необходимо добавить репозиторий https://dl.google.com/android/repository/repository-11.xml
echo -e "${YEL}Скачиваю и распаковываю платформу android-22${NC}"
wget https://dl.google.com/android/repository/android-22_r02.zip
unzip android-22_r02.zip
mkdir tools/platforms
mv android-5.1.1 tools/platforms/android-22

echo -e "${YEL}Скачиваю и распаковываю инструменты для платформы r26.0.2${NC}"
wget https://dl.google.com/android/repository/platform-tools_r26.0.2-linux.zip
unzip platform-tools_r26.0.2-linux.zip -d tools/

mv tools android-sdk-linux

echo export MYANDROID="$(pwd)" >> ~/.bashrc
cp $(dirname $0)/generate_android_build_script.sh ./
echo export MYANDROID_GEN="$(pwd)/generate_android_build_script.sh" >> ~/.bashrc
