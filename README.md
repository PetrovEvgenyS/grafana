# Скрипт установки Grafana

Этот скрипт автоматизирует установку Grafana на серверах с ОС Ubuntu или AlmaLinux.

## Особенности

- Определение дистрибутива Linux.
- Установка необходимых пакетов и репозиториев.
- Настройка firewall (для AlmaLinux).
- Автоматический запуск и включение Grafana.

## Требования

- Права root или запуск через `sudo`.
- Поддерживаемые ОС: Ubuntu, AlmaLinux.

## Использование

1. Сделайте скрипт исполняемым:
   ```bash
   chmod +x install_grafana.sh
   ```

2. Запустите скрипт:
   ```bash
   sudo ./install_grafana.sh
   ```

## Примечания

- По умолчанию Grafana доступна на порту `3000`.
- Логин и пароль по умолчанию: `admin` / `admin`.

## Ссылки

- [Документация Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/installation/)