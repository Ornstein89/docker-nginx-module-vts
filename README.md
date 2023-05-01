# Сборка Nginx с модулями в Docker

Проект предназначен для подготовки контейнеризованного `nginx` с модулями, на основе только исходного кода и официальных образов Docker. В данном репозитории продемонстрировано добавление модуля [nginx-module-vts](https://github.com/vozlt/nginx-module-vts), предназначенного для получения метрик `nginx`, в т.ч. для `prometheus`. Однако приведённые подходы позволяют собирать контейнеры `nginx` с любыми модулями, как динамическими (обе приведённых методики), так и подключаемыми при сборке ([Методика 2](#2-сборка-nginx-и-модулей-совместно-в-одном-контейнере-из-исходного-кода)).

![Демонстрация панели модуля nginx-module-vts](./doc/images/screenshot.png)

## Оглавление

- [Сборка Nginx с модулями в Docker](#сборка-nginx-с-модулями-в-docker)
  - [Оглавление](#оглавление)
  - [Содержание репозитория](#содержание-репозитория)
  - [Методики](#методики)
    - [1. Сборка динамического модуля в отдельной ступени и перенос в целевой образ nginx](#1-сборка-динамического-модуля-в-отдельной-ступени-и-перенос-в-целевой-образ-nginx)
      - [Инструкция](#инструкция)
    - [2. Сборка nginx и модулей совместно в одном контейнере из исходного кода](#2-сборка-nginx-и-модулей-совместно-в-одном-контейнере-из-исходного-кода)
      - [Инструкция](#инструкция-1)
  - [Диагностика и устранение неисправностей](#диагностика-и-устранение-неисправностей)
  - [TODO](#todo)
  - [Источники](#источники)

## Содержание репозитория

- `build_separate` - каталог с `Dockerfile`'ами для сборки динамического модуля и `nginx` в отдельных контейнерах ([Методика 1](#1-сборка-динамического-модуля-в-отдельном-контейнере-и-перенос-в-контейнер-nginx)).
- `build_with_nginx` - каталог с `Dockerfile`'ом для сборки только `nginx` с модулем в одном контейнере ([Методика 2](#2-сборка-nginx-и-модулей-совместно-в-одном-контейнере-из-исходного-кода)).

## Методики

### 1. Сборка динамического модуля в отдельной ступени и перенос в целевой образ nginx

Преимущества:

- ступени сборки просты по отдельности и не требуют высокой экспертизы,
- нет необходимости воспроизводить сложный процесс сборки (и компактирования) всего контейнера `nginx`, можно использовать как основу компактный официальный образ `nginx` и дополнить его собранным модулем,
- используется только исходный код и официальный образ `nginx` (в данном репозитории - `nginx:1.24.0-alpine-slim`), без сторонних пользовательских образов Docker Hub.

Недостатки:

- необходимо соблюдать синхронность версий `nginx` и  зависимостей в целевом и сборочном контейнерах.

#### Инструкция

1. Перейти в каталог `build_separate`. Файл содержит 2 ступени сборки, на первой во временном сборочном контейнере `alpine` собирается динамический модуль `nginx-module-vts` из исходного кода со всеми необходимыми зависимостями, на втором - модуль копируется в целевой контейнер (официальная сборка `nginx:1.24.0-alpine-slim`). При желании изменить в `Dockerfile`
   - тип дистрибутива `linux` (для обеих ступеней сборки должен быть одинаковый),
   - версию `nginx` в аргументе `ARG_NGINX_VERSION` (**при этом образ `nginx` для финальной ступени сборки выбирать той же вресии!**),
   - собираемые модули (организовать скачивание исходного кода и подключение модуля в `./configure ... --add-dynamic-module=...`),
   - файлы конфигурации `nginx.conf` и `default.conf`.
2. Собрать образ из `Dockerfile`.

    ```bash
    sudo docker build -t ornstein89/nginx_with_modules1 .
    ```

    WSL (*Windows + WSL2 + Docker desktop*):

    ```bash
    docker.exe build -t ornstein89/nginx_with_modules1 .
    ```

3. Запустить контейнер из собранного образа. Убедиться, что статистика, выдаваемая модулем `nginx-module-vts`, доступна по URL <http://localhost/status>.

    Ubuntu:

    ```bash
    sudo docker run --name nginx_with_modules1 -p 80:80 -p 443:443 ornstein89/nginx_with_modules1
    ```

    WSL (*Windows + WSL2 + Docker desktop*):

    ```bash
    docker.exe run --name nginx_with_modules1 -p 80:80 -p 443:443 ornstein89/nginx_with_modules1
    ```

### 2. Сборка nginx и модулей совместно в одном контейнере из исходного кода

Преимущества этого подхода:

- используется только исходный код и официальный образ `linux` (в данном репозитории - `alpine`), без сторонних пользовательских образов Docker Hub.

Недостатки:

- при сборке `nginx` из исходного кода сложно обеспечить компактность контейнера, сравнимую с официальными сборками; для уменьшения размера образа после сборки требуется либо высокая экспертность в дистрибутивах `linux` и зависимостях `nginx`.

#### Инструкция

1. Перейти в каталог `build_with_nginx`. В `Dockerfile` в переменной `NGINX_BUILD_VERSION` задать желаемую версию `nginx` (на 30 апреля 2023 года - версия `1.24.0`).

2. Сборка образа `nginx` с модулем.

    Ubuntu:

    ```bash
    sudo docker build -t ornstein89/alpine-nginx-modules .
    ```

    WSL (*Windows + WSL2 + Docker desktop*):

    ```bash
    docker.exe build -t ornstein89/alpine-nginx-modules .
    ```

3. Запуск. Убедиться, что статистика, выдаваемая модулем `nginx-module-vts`, доступна по URL <http://localhost/status>.

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

- [x] Использовать `apk --virtual NAME add && apk del NAME` для уменьшения объёма (350Мб → 100Мб).
- [x] Собирать динамический модуль на отдельном контейнере, а затем перенести на контейнер `nginx`.
- [x] Multi-stage build для метода 1.
- [ ] Метод 2, перейти на основу из <https://github.com/nginxinc/docker-nginx> и <https://hg.nginx.org/pkg-oss/>, сократить объём образа.
- [ ] Internationalization.
- [ ] Compose для метода 1.

## Источники

- Решение проблем с отсутствием библиотек на alpine <https://artem.services/?p=1093>.
- Сборка nginx <https://stackoverflow.com/questions/60324262/compiling-nginx-on-alpine-linux-3-11>.
- Сборка nginx <https://github.com/LoicMahieu/alpine-nginx>.
- Документация по конфигурированию и сборке `nginx` из исходников <https://nginx.org/en/docs/configure.html>.
- Сборка модуля и nginx в одном контейнере <https://wiki.hydra-billing.ru/pages/viewpage.action?pageId=69173413>.
- Сборка динамического модуля <https://habr.com/ru/companies/nixys/articles/473578/>.
- Статья Nginx Inc по сборке динамического модуля <https://www.nginx.com/blog/compiling-dynamic-modules-nginx-plus/>.
- Сборка модуля в отдельном контейнере <https://gist.github.com/hermanbanken/96f0ff298c162a522ddbba44cad31081>.
