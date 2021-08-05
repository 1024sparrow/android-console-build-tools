#!/bin/bash
# генератор сборочного скрипта для проекта под Android
# copyright 2018-2021, Васильев Борис (1024sparrow@gmail.com)

function generateNewProjectSources {
    local appname=$1
    local apppath=$2
    local apppathDotes=$(echo $apppath | sed 's/\//./g')

    #echo "apppathDotes: $apppathDotes"
    #echo "apppath: $apppath"
    #echo "appname: $appname"

    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"
          package=\"${apppathDotes}\"
          versionCode=\"1\"
          versionName=\"0.1\">
    <uses-sdk android:minSdkVersion=\"16\"/>
    <application android:label=\"Hello\">
        <activity android:name=\".MainActivity\">
            <intent-filter>
                <action android:name=\"android.intent.action.MAIN\"/>
                <category android:name=\"android.intent.category.LAUNCHER\"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
" > AndroidManifest.xml

    mkdir -p res/layout
    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<LinearLayout
    xmlns:android=\"http://schemas.android.com/apk/res/android\"
    android:layout_width=\"match_parent\"
    android:layout_height=\"match_parent\"
    android:gravity=\"center\"
    android:orientation=\"vertical\">

    <TextView
        android:layout_width=\"wrap_content\"
        android:layout_height=\"wrap_content\"
        android:id=\"@+id/my_text\"/>
</LinearLayout>
" > res/layout/activity_main.xml

    mkdir -p java/$apppath
    pushd java/$apppath
        echo "package ${apppathDotes};

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView text = (TextView)findViewById(R.id.my_text);
        text.setText(\"Hello, world!\");
    }
}" > MainActivity.java
    popd
} # function generateNewProjectSources

appname=""
apppath=""
if [ -e AndroidManifest.xml ]
then
    echo Обнаружен файл AndroidManifest.xml. Беру параметры сборки из него.
    tmp=$(cat AndroidManifest.xml | grep package)
    tmp=$(expr match $tmp 'package=\"\([^\"]*\)')
    set -f
    array=(${tmp//./ })
    #IFS='.' read -r -a array <<< "$tmp"
    for element in "${array[@]}"
    do
        appname=$element
        if [ ! -z "$apppath" ]; then apppath=$apppath/; fi
        apppath=${apppath}${element}
    done

    echo $appname
    echo $apppath
    
    #echo $(expr index $tmp2 '\([^.]*\)')
else
    echo Файл AndroidManifest.xml не обнаружен - будем создавать новый проект
    echo ========================================
    echo Пример:
    echo Название проекта: webandroidapp
    echo Путь проекта: ru/mycompany/webandroidapp
    echo ========================================
    echo -n "Введите название проекта: "
    read appname
    if [[ -z $appname ]]
    then
        exit 0
    fi
    echo -n "Введите путь проекта: "
    read apppath
    if [[ -z $apppath ]]
    then
        echo qq
        exit 0
    fi
    generateNewProjectSources $appname $apppath
fi

echo -n "Название скрипта сборки (build.sh по умолчанию):"
read scriptname
if [ -z $scriptname ]
then
    scriptname=build.sh
fi

if [ -e $scriptname ]
then
    echo -n Файл $scriptname уже существует. Нажмите ENTER для замены. Для прерывания операции введите что-нибудь.
    read answ
    if [[ ! -z $answ ]]; then exit 0; fi
    rm -rf $scriptname
fi
touch $scriptname

#appname=webandroidapp
#apppath=com/org/zl/webandroidapp

#==========================
#export MYANDROID_SDK="$(pwd)/android-sdk-linux" >> ~/.bashrc
#export MYANDROID_BUILD_TOOLS="${MYANDROID_SDK}/build-tools/27.0.1" >> ~/.bashrc
#export MYANDROID_PLATFORM="${MYANDROID_SDK}/platforms/android-22" >> ~/.bashrc
#export MYANDROID_PATH="$MYANDROID_SDK/platform-tools":"$MYANDROID_SDK/build-tools/27.0.1":"$MYANDROID_SDK":"$PATH" >> ~/.bashrc

#==========================
echo "#!/bin/bash
# скрипт, собирающий проект под Android
# Реализация основана на статье, расположенной по адресу http://www.hanshq.net/command-line-android.html

appname=${appname}
apppath=${apppath}
apppathDotes=$(echo $apppath | sed 's/\//./g')
mainActivityName=MainActivity

source $MYANDROID/environments/2

RED='\033[0;31m'
YEL='\033[1;33m'
NC='\033[0m'

function error_quite {
    echo -e \"\${RED}Сборка прервана из-за возникшей ошибки\${NC}\"
    exit 1
}

echo -e \"\${YEL}Удаляем build (предыдущую сборку)\${NC}\"
rm -rf build

echo -e \"\${YEL}Создаём директории, куда будет производиться сборка\${NC}\"
mkdir -p build/gen build/obj build/apk || error_quite

echo -e \"\${YEL}Генерируем java-файлы (R.java), отображающие содержимое ресурсов (которые описаны в XML)\${NC}\"
\"\${BUILD_TOOLS}/aapt\" package -f -m -J build/gen/ -S res -M AndroidManifest.xml -I \"\${PLATFORM}/android.jar\" || error_quite

echo -e \"\${YEL}Собираем байт-код для нашего Java-приложения. Делаем байт-код для версии Java 7.\${NC}\"
javac -source 1.7 -target 1.7 -bootclasspath \"\${JAVA_HOME}/jre/lib/rt.jar\" -classpath \"\${PLATFORM}/android.jar\" -d build/obj build/gen/\${apppath}/R.java java/\${apppath}/MainActivity.java || error_quite
echo \"Вот мы получили байт-код Java (файлы .class). Но Android использует байт-код другого формата - Dalvik (файлы .dex)\"

echo -e \"\${YEL}Преобразуем стандартный байт-код в Андроидовский (Dalvik) байт-код\${NC}\"
\"\${BUILD_TOOLS}/dx\" --dex --output=build/apk/classes.dex build/obj/ || error_quite

echo -e \"\${YEL}Запаковываем .dex-файлы, манифест и ресурсы в APK\${NC}\"
#\"\${BUILD_TOOLS}/aapt\" package -f -M AndroidManifest.xml -A assets -S res/ -I \"\${PLATFORM}/android.jar\" -F build/\${appname}.unsigned.apk build/apk/ || error_quite
\"\${BUILD_TOOLS}/aapt\" package -f -M AndroidManifest.xml -S res/ -I \"\${PLATFORM}/android.jar\" -F build/\${appname}.unsigned.apk build/apk/ || error_quite
echo \"У нас есть apk-файл, но прежде чем его устанавливать на смартфон, его необходимо подписать...\"

echo -e \"\${YEL}Делаем так, чтобы после распаковки нашего apk файлы были выровнены по размеру блока 4 байта\${NC}\"
\"\${BUILD_TOOLS}/zipalign\" -f -p 4 build/\${appname}.unsigned.apk build/\${appname}.aligned.apk || error_quite

if [ ! -f keystore.jks ]
then
    echo -e \"\${YEL}Генерируем ключ (будут запрашиваться данные у пользователя)\${NC}\"
    keytool -genkeypair -keystore keystore.jks -alias androidkey -validity 10000 -keyalg RSA -keysize 2048 -storepass android -keypass android || error_quite
fi

echo -e \"\${YEL}Подписываем полученным ключом наш apk\${NC}\"
\"\${BUILD_TOOLS}/apksigner\" sign --ks keystore.jks --ks-key-alias androidkey --ks-pass pass:android --key-pass pass:android --out build/\${appname}.apk build/\${appname}.aligned.apk || error_quite

echo \"#!/bin/bash
# установка приложения на устройство пользователя по USB

adb install -r build/\$(basename ${apppath}).apk
adb shell am start -n \${apppathDotes}/\${apppathDotes}.\${mainActivityName}
\" > deploy_and_run.sh
chmod +x deploy_and_run.sh
" > $scriptname

if ! which adb
then
    echo 'Не забудьте установить "adb"! В Ubuntu-20.04 это делается командой "sudo apt install adb"'
fi > /dev/null


chmod +x $scriptname
