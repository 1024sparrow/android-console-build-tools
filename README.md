# android-console-build-tools
console build tools for building android applications.

Перед вами bash-скрипт, который закачивает, распаковывает, как надо расставляет Android-SDK, Android-NDK и всё то, что нужно для сборки.
Практическая реализация рецептов, описанных в [статье](https://www.hanshq.net/command-line-android.html)

# Системные требования
Для установки вам потребуется JDK. Архив весит 339 МБ.
Сам скрипт накачает ещё 1.1 ГБ архивов.
После распаковки всё это добро отъест от вашего жёсткого диска 5.2 ГБ памяти.

# Инструкция по установке
1. Создайте диреторию myandroid, в которой будет располагаться JAVA-SDK и прочие бинарники.
2. Положите туда файл jdk-9.0.1_linux-x64_bin.tar.gz. Его можно взять [здесь](http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase9-3934878.html (только JDK))
3. Зайдите в директорию myandroid и, находясь там, запустите скрипт install.sh из этой директории

# После установки (использование)
В директории с проектом (или пустой директории, если проект надо создать)
выполните $MYANDROID_GEN
будет создан скрипт, с помощью которого вы сможете собрать проет

## Лицензия

Copyright © 2018 [Васильев Борис](https://github.com/1024sparrow)
Публикуется под лицензией [MIT license](https://github.com/1024sparrow/android-console-build-tools/blob/master/LICENSE).
