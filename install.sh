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

if [ ! -d environments ]
then
    mkdir environments
fi
echo 'JAVA_HOME=${MYANDROID}/tools/jdk/jdk-9
PATH=${JAVA_HOME}/bin:$PATH
SDK="${MYANDROID}"/tools
BUILD_TOOLS="${MYANDROID}"/tools/build-tools/27.0.1
PLATFORM="${SDK}"/platforms/android-22
PATH="$SDK"/platform-tools:"$SDK"/build-tools/27.0.1:"$SDK":"$PATH"
BUILD_TARGET_DESCRIPTION="Android 5.1.1 (API level 22)"
' > environments/1

echo 'JAVA_HOME=${MYANDROID}/tools/jdk/jdk-9
PATH=${JAVA_HOME}/bin:$PATH
SDK="${MYANDROID}"/tools
BUILD_TOOLS="${MYANDROID}"/tools/build-tools/27.0.1
PLATFORM="${SDK}"/platforms/android-24
PATH="$SDK"/platform-tools:"$SDK"/build-tools/27.0.1:"$SDK":"$PATH"
BUILD_TARGET_DESCRIPTION="Android 7.0 (API level 24)"
' > environments/2

#echo 'JAVA_HOME=/snap/android-studio/114/android-studio/jre
##JAVA_HOME=${MYANDROID}/java-se-9-ri/jdk-9
#PATH=${JAVA_HOME}/bin:$PATH
#SDK=/home/boris/Android/Sdk/tools
##BUILD_TOOLS=/home/boris/Android/Sdk/build-tools/29.0.3
#BUILD_TOOLS="${MYANDROID}"/android-sdk-linux/build-tools/27.0.1
#PLATFORM=/home/boris/Android/Sdk/platforms/android-29
#export PATH="$BUILD_TOOLS":"$SDK":"$PATH"
#BUILD_TARGET_DESCRIPTION="Android 10 (API level 29)"
#' > environments/4

echo 'JAVA_HOME=${MYANDROID}/tools/jdk/jdk-11
BUILD_TOOLS="${MYANDROID}"/tools/build-tools/27.0.1
PLATFORM="${MYANDROID}"/tools/platforms/android-29
export PATH="$BUILD_TOOLS"/27.0.1:"$JAVA_HOME":"$PATH"
BUILD_TARGET_DESCRIPTION="Android 10 (API level 29)"
SDK_VERSION=29
' > environments/4

#echo 'JAVA_HOME=${MYANDROID}/java-se-9-ri/jdk-9
#PATH=${JAVA_HOME}/bin:$PATH
#SDK="${MYANDROID}"/android-sdk-linux
#BUILD_TOOLS="${SDK}"/build-tools/27.0.1
#PLATFORM="${SDK}"/platforms/android-27
#PATH="$SDK"/platform-tools:"$SDK"/build-tools/27.0.1:"$SDK":"$PATH"
#BUILD_TARGET_DESCRIPTION="Android 8.1 (API level 27)"
#' > environments/3

# see sources at https://jdk.java.net/ . It's all OpenJDK.

if [ ! -f openjdk-9+181_linux-x64_ri.zip ]
then
    # dir java-se-9-ri/jdk-9
    echo -e "${YEL}Скачиваю и распаковываю JDK-9${NC}"
    mkdir -p tools/jdk
    wget https://download.java.net/openjdk/jdk9/ri/openjdk-9+181_linux-x64_ri.zip &&
        unzip openjdk-9+181_linux-x64_ri.zip &&
        mv java-se-9-ri/jdk-9 tools/jdk/jdk-9 &&
        rm -r java-se-9-ri ||
        (
            echo "can not download and prepare jdk9";
            exit 1
        )
fi

if [ ! -f openjdk-11+28_linux-x64_bin.tar.gz ]
then
    # dir jdk-11
    echo -e "${YEL}Скачиваю и распаковываю JDK-11${NC}"
    mkdir -p tools/jdk
    wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz &&
    tar -xf openjdk-11+28_linux-x64_bin.tar.gz &&
    mv jdk-11 tools/jdk/jdk-11 ||
    (
        echo "can not download and prepare jdk11";
        exit 1
    )
fi


# https://dl.google.com/android/repository/platform-tools-latest-linux.zip
# https://dl.google.com/android/repository/platform-tools_r31.0.3-linux.zip
if [ ! -f sdk-tools-linux-3859397.zip ]
then
    echo -e "${YEL}Скачиваю и распаковываю sdk-tools${NC}"
    wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
    unzip sdk-tools-linux-3859397.zip
fi

if [ ! -f build-tools_r27.0.1-linux.zip ]
then
    echo -e "${YEL}Скачиваю и распаковываю build-tools${NC}"
    wget https://dl.google.com/android/repository/build-tools_r27.0.1-linux.zip # api v.27 (Android 8.1)
    unzip build-tools_r27.0.1-linux.zip
    mkdir -p tools/build-tools
    mv android-8.1.0 tools/build-tools/27.0.1
fi

#if [ ! -f android-ndk-r16-linux-x86_64.zip ]
#then
#    echo -e "${YEL}Скачиваю и распаковываю ndk${NC}"
#    wget https://dl.google.com/android/repository/android-ndk-r16-linux-x86_64.zip
#    unzip android-ndk-r16-linux-x86_64.zip
#fi

# Запускаем android-studio. Открываем SDK Manager. Appearance&Behaviour -> System Settings --> Android SDK.
# Вкладка SDK Update Sites. По этому адресу можно увидеть XML с перечнем доступных платформ. Выбираем, подменяем в адресе на указанный в XML android-xxxx.zip и скачиваем
# По состоянию на март 2018 года самый свежий - https://dl.google.com/android/repository/repository2-1.xml
# Для разработки в студии и сборки вручную я брал (мог бы взять, кабы не старая версия андроида на моём устройстве) https://dl.google.com/android/repository/platform-26_r02.zip
# Для того, чтобы в студии можно было разрабатывать под моё (старое) устройство, необходимо добавить репозиторий https://dl.google.com/android/repository/repository-11.xml
if [ ! -f android-22_r02.zip ]
then
    echo -e "${YEL}Скачиваю и распаковываю платформу android-22${NC}"
    wget https://dl.google.com/android/repository/android-22_r02.zip
    unzip android-22_r02.zip
    mkdir -p tools/platforms
    mv android-5.1.1 tools/platforms/android-22
fi

if [ ! -f platform-24_r02.zip ]
then
    echo -e "${YEL}Скачиваю и распаковываю платформу android-24${NC}"
    wget https://dl.google.com/android/repository/platform-24_r02.zip
    unzip platform-24_r02.zip
    mkdir -p tools/platforms
    mv android-7.0 tools/platforms/android-24
fi

if [ ! -f platform-29_r04.zip ]
then
    echo -e "${YEL}Скачиваю и распаковываю платформу android-29${NC}"
    wget https://dl.google.com/android/repository/platform-29_r04.zip
    unzip platform-29_r04.zip
    mkdir -p tools/platforms
    mv android-10 tools/platforms/android-29
fi

#if [ ! -f platform-27_r03.zip ]
#then
#    echo -e "${YEL}Скачиваю и распаковываю платформу android-27${NC}"
#    wget https://dl.google.com/android/repository/platform-27_r03.zip
#    unzip platform-27_r03.zip
#    mkdir tools/platforms
#    mv android-8.1.0 tools/platforms/android-27
#fi

#if [ ! platform-tools_r26.0.2-linux.zip ]
#then
#    echo -e "${YEL}Скачиваю и распаковываю инструменты для платформы r26.0.2${NC}"
#    wget https://dl.google.com/android/repository/platform-tools_r26.0.2-linux.zip
#    unzip platform-tools_r26.0.2-linux.zip -d tools/
#fi

#mv tools android-sdk-linux


if [ -z $MYANDROID ]
then
    echo export MYANDROID="$(pwd)" >> ~/.bashrc
    echo export MYANDROID_GEN="$(pwd)/generate_android_build_script.sh" >> ~/.bashrc
fi

