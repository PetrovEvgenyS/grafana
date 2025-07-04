# Скрипты установки Grafana

В этом репозитории два скрипта для автоматизации установки Grafana на серверах с ОС Ubuntu или AlmaLinux:

- `install_grafana.sh` — базовая установка Grafana.
- `install_grafana_for_prometheus.sh` — установка Grafana с автоматическим добавлением источника данных Prometheus.

## Особенности

- Определение дистрибутива Linux.
- Установка необходимых пакетов и репозиториев.
- Настройка firewall (для AlmaLinux).
- Автоматический запуск и включение Grafana.
- Для скрипта `install_grafana_for_prometheus.sh`: автоматическое добавление Prometheus как источника данных (адрес Prometheus указывается в переменной `PROMETHEUS_URL`).

## Требования

- Права root или запуск через `sudo`.
- Поддерживаемые ОС: Ubuntu, AlmaLinux.

## Использование

### Обычная установка Grafana

1. Сделайте скрипт исполняемым:
   ```bash
   chmod +x install_grafana.sh
   ```
2. Запустите скрипт:
   ```bash
   sudo ./install_grafana.sh
   ```

### Установка Grafana с Prometheus

1. При необходимости отредактируйте переменную `PROMETHEUS_URL` в начале скрипта.
2. Сделайте скрипт исполняемым:
   ```bash
   chmod +x install_grafana_for_prometheus.sh
   ```
3. Запустите скрипт:
   ```bash
   sudo ./install_grafana_for_prometheus.sh
   ```

## Примечания

- По умолчанию Grafana доступна на порту `3000`.
- Логин и пароль по умолчанию: `admin` / `admin`.

## Ссылки

- [Документация Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/installation/)