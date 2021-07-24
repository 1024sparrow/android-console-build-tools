# android-console-build-tools
console build tools for building android applications.

Осторожно! LINUX-специфичное ПО!	

Перед вами bash-скрипт, который закачивает, распаковывает, как надо расставляет Android-SDK, Android-NDK и всё то, что нужно для сборки.
Практическая реализация рецептов, описанных в [статье](https://www.hanshq.net/command-line-android.html)

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
3. Зайдите в директорию myandroid и, находясь там, запустите скрипт install.sh из этой директории
```bash
$ cd ~/opt/myandroid
$ git clone https://gitflic.ru/project/1024sparrow/android-console-build-tools.git
```

# После установки (использование)
В директории с проектом (или пустой директории, если проект надо создать)
выполните $MYANDROID_GEN
будет создан скрипт, с помощью которого вы сможете собрать проект

## Лицензия

Copyright © 2018 [Васильев Борис](https://github.com/1024sparrow)
Публикуется под лицензией [MIT license](https://github.com/1024sparrow/android-console-build-tools/blob/master/LICENSE).
