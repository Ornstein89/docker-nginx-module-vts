# Сборка nginx на alpine linux

Проект предназначен, главным образом, для подготовки контейнеризованного `nginx` с расширениями, требующими сборки `nginx` из исходного кода (например, [nginx-module-vts](https://github.com/vozlt/nginx-module-vts)).

## Инструкция

Ubuntu:

```bash
sudo docker build nginx-module-vts
```

WSL (*Windows + WSL2 + Docker desktop*):

```bash
docker.exe build -t ornstein89/alpine-nginx-modules nginx-module-vts
```

## Источники

* Решение проблем с отсутствием библиотек на alpine <https://artem.services/?p=1093>.
* Аналогичная сборка <https://stackoverflow.com/questions/60324262/compiling-nginx-on-alpine-linux-3-11>.
* Аналогичная сборка <https://github.com/LoicMahieu/alpine-nginx>.
* Документация по конфигурированию и сборке `nginx` <https://nginx.org/en/docs/configure.html>.
