# Nginx с модулями в Docker

Проект предназначен, главным образом, для подготовки контейнеризованного `nginx` с модулями.

В данном контейнере в `nginx` добавлен модуль [nginx-module-vts](https://github.com/vozlt/nginx-module-vts).

![nginx-module-vts](./doc/images/screenshot.png)

## Инструкция

1. В `Dockerfile` в переменной `NGINX_BUILD_VERSION` задайте желаемую версию `nginx` (на 30 апреля 2023 года - версия `1.24.0`).

2. Сборка образа

    Ubuntu:

    ```bash
    sudo docker build -t ornstein89/alpine-nginx-modules .
    ```

    WSL (*Windows + WSL2 + Docker desktop*):

    ```bash
    docker.exe build -t ornstein89/alpine-nginx-modules .
    ```

3. Запуск:

    Ubuntu:

    ```bash
    sudo docker run --name alpine-nginx-modules ornstein89/alpine-nginx-modules
    ```

    WSL (*Windows + WSL2 + Docker desktop*):

    ```bash
    docker.exe run --name alpine-nginx-modules ornstein89/alpine-nginx-modules
    ```

## Диагностика и устранение неисправностей

1. Диагностический запуск с переходом в терминал контейнера:

    Ubuntu:

    ```bash
    sudo docker run --name alpine-nginx-modules -a stdin -a stdout -it ornstein89/alpine-nginx-modules sh
    ```

    WSL (*Windows + WSL2 + Docker desktop*):

    ```bash
    docker.exe run --name alpine-nginx-modules -a stdin -a stdout -it ornstein89/alpine-nginx-modules sh
    ```

## TODO

* [x] Использовать `apk --virtual NAME add && apk del NAME` для уменьшения объёма (350Мб → 100Мб).
* [ ] Перейти на основу из <https://github.com/nginxinc/docker-nginx> и <https://hg.nginx.org/pkg-oss/>.
* [ ] Собирать 

## Источники

* Решение проблем с отсутствием библиотек на alpine <https://artem.services/?p=1093>.
* Аналогичная сборка <https://stackoverflow.com/questions/60324262/compiling-nginx-on-alpine-linux-3-11>.
* Аналогичная сборка <https://github.com/LoicMahieu/alpine-nginx>.
* Документация по конфигурированию и сборке `nginx` <https://nginx.org/en/docs/configure.html>.
* Аналогичная сборка <https://wiki.hydra-billing.ru/pages/viewpage.action?pageId=69173413>.
* Сборка динамического модуля <https://habr.com/ru/companies/nixys/articles/473578/>.
