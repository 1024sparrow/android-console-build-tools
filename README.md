# android-console-build-tools
console build tools for building android applications.

Осторожно! LINUX-специфичное ПО!	

Перед вами bash-скрипт, который закачивает, распаковывает, как надо расставляет Android-SDK, Android-NDK и всё то, что нужно для сборки.
Практическая реализация рецептов, описанных в [статье](https://www.hanshq.net/command-line-android.html). Не ревлизована сборка с участием NDK - см. статьи [исходную](https://www.hanshq.net/command-line-android.html) и [ещё одну](https://www.hanshq.net/othello.html)
Теперь для создания нового приложения под Андроид или сборки имеющегося вам не нужна AndroidStudio !

# Системные требования
Для установки вам потребуется JDK. Архив весит 339 МБ.
Сам скрипт накачает ещё 1.1 ГБ архивов.
После распаковки всё это добро отъест от вашего жёсткого диска 5.2 ГБ памяти.

# Инструкция по установке
> ВНИМАНИЕ! Перед тем как скачивать себе данный репозиторий, прочитайте инструкцию по установке.
1. Создайте диреторию myandroid, в которой будет располагаться JAVA-SDK и прочие бинарники.
	```bash
	$ mkdir -p ~/opt/myandroid
	```
2. Положите туда файл jdk-9.0.1_linux-x64_bin.tar.gz. Его можно взять [здесь](http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase9-3934878.html (только JDK))
	```
	Перейдите по ссылке и скачайте файл jdk-9.0.1_linux-x64_bin.tar.gz .
	Скачать могут только авторизованные пользователи.
	Так что, если у вас нет учётной записи, вам необходимо будет зарегистрироваться на сайте oracle.com .
	Скачанный файл сохраните в директорию ~/opt/myandroid/jdk-9.0.1_linux-x64_bin.tar.gz
	```
3. Зайдите в директорию myandroid, скачайте данный репозиторий и, запустите скрипт install.sh, не переходя в директорию скачанного репозитория
	```bash
	$ cd ~/opt/myandroid
	$ git clone https://gitflic.ru/project/1024sparrow/android-console-build-tools.git
	$ android-console-build-tools/install.sh
	```

# После установки (использование)

## Сборка проекта, созданного ранее с помощью Android Studio

Если у вас уже есть код проекта, то в директории, в которой располагается AndroidManifest.xml , необходимо выполнить скрипт, путь до которого сохранён в переменной окружения $MYANDROID_GEN. Если проект был создан с помощью Android-Studio, то корень исходников проекта, располагается в поддиректории ```app/src/main/```.
```bash
$ cd ...
$ cd app/src/main
$ $MYANDROID_GEN
$ ./build.sh # если во время работы мастера создания собирающего скрипта вы оставили название сборочного скрипта по умолчанию
```

## Создание нового проекта с нуля

Создайте директорию проекта, перейдите в неё, запустите скрипт $MYANDROID_GEN и следуйте указаниям мастера создания нового проекта

```bash
$ mkdir ~/helloAndroid
$ cd ~helloAndroid
$ $MYANDROID_GEN
```

## Лицензия

Copyright © 2018-2021 [Васильев Борис](https://github.com/1024sparrow)
Публикуется под лицензией [MIT license](https://github.com/1024sparrow/android-console-build-tools/blob/master/LICENSE).
