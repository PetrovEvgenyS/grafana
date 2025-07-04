#!/bin/bash
# Install Grafana for Prometheus
# https://grafana.com/docs/grafana/latest/setup-grafana/installation/

### ЦВЕТА ##
ESC=$(printf '\033') RESET="${ESC}[0m" MAGENTA="${ESC}[35m" RED="${ESC}[31m" GREEN="${ESC}[32m"

### Функции цветного вывода ##
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }
errorprint() { printf "${RED}%s${RESET}\n" "$1"; }
greenprint() { printf "${GREEN}%s${RESET}\n" "$1"; }

# Указываем адрес сервера PROMETHEUS
PROMETHEUS_URL="http://10.100.10.5:9090"

# -------------------------------------------------------------------------------- #

# Проверка прав root
if [ "$(id -u)" -ne 0 ]; then
    errorprint "Этот скрипт должен запускаться с правами root или через sudo!"
    exit 1
fi

# Определение дистрибутива:
if [ -f /etc/os-release ]; then
    OS=$(awk -F= '/^ID=/{gsub(/"/, "", $2); print $2}' /etc/os-release)
else
    errorprint "Не удалось определить дистрибутив Linux!"
    exit 1
fi

# Выбор ОС для установки необходимых пакетов:
check_os() {
  if [ "$OS" == "ubuntu" ]; then
      install_grafana_ubuntu
  elif [ "$OS" == "almalinux" ]; then
      install_grafana_almalinux
  else
      errorprint "Скрипт не поддерживает установленную ОС: $OS"
      # Выход из скрипта с кодом 1.
      exit 1
  fi
}

# Функция установки необходимых пакетов и Grafana на Ubuntu:
install_grafana_ubuntu() {
  magentaprint "Выполняется установка Grafana на $OS"
  
  # Установите необходимые пакеты:
  apt update
  apt install -y apt-transport-https software-properties-common wget \ 
    || { errorprint "Не удалось установить необходимые пакеты"; exit 1; }
  
  # Импортируйте ключ GPG (возможно, потребуется VPN):
  mkdir -p /etc/apt/keyrings/
  wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null

  # Добавление репозитория Grafana
  echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list

  # Обновление списка пакетов:
  apt update
  # Установка Grafana:
  apt install -y grafana
}

# Функция установки необходимых пакетов и Grafana на AlmaLinux:
install_grafana_almalinux() {
  magentaprint "Выполняется установка Grafana на $OS"
  
  # Установите необходимые пакеты:
  dnf -y update
  dnf -y install wget || { errorprint "Не удалось установить необходимые пакеты"; exit 1; }

  # Импортируйте ключ GPG:
  wget -q -O gpg.key https://rpm.grafana.com/gpg.key
  rpm --import gpg.key
  rm -f /tmp/gpg.key

  # Добавление репозитория Grafana:
  tee /etc/yum.repos.d/grafana.repo > /dev/null <<EOF
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

  # Установка Grafana:
  dnf install -y grafana

  # Вызов функции firewall_almalinux
  firewall_almalinux
}

# Функция настройки firewall:
firewall_almalinux() {
  magentaprint "Выполняется настройка firewalld на AlmaLinux"

  firewall-cmd --permanent --add-port=3000/tcp || { errorprint "Не удалось открыть порт 3000"; exit 1; }
  firewall-cmd --reload || { errorprint "Не удалось перезагрузить firewalld"; exit 1; }
}

# Функция настройки datasources:
settings_datasources() {
  tee /etc/grafana/provisioning/datasources/prometheus.yaml > /dev/null <<EOF
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    url: ${PROMETHEUS_URL}
EOF
}

# Запуск и включение Grafana:
start_enable_grafana() {
  magentaprint "Запуск и включение Grafana"
  systemctl enable --now grafana-server
}

# Функция проверки состояния Grafana:
check_status_grafana() {
  magentaprint "Проверяем состояние Grafana:"

  systemctl status grafana-server --no-pager
  grafana-server --version
  echo "Grafana успешно установлен и настроен на $OS."
  echo "По умолчанию логин и пароль: admin"
}

# Создание функций main
main() {
  check_os
  settings_datasources
  start_enable_grafana
  check_status_grafana
}

# Вызов функции main
main
