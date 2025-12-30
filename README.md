# dpdk-test-rxtx_callbacks
Модифицированный пример DPDK rxtx_callbacks с функцией генерации тестового трафика и измерением задержки обработки пакетов.

## Быстрый запуск
```bash
# 1. Клонировать репозиторий
git clone https://github.com/LapshinAE0/dpdk-test-rxtx_callbacks.git
cd dpdk-test-rxtx_callbacks

# 2. Запустить сборку
./setup.sh

# 3. В контейнере запустить тест (вход в контейнер производится автоматически)
./scripts/run_example_dpdk.sh
```

## Структура проекта
```text
├── Dockerfile               # Сборка образа с DPDK
├── setup.sh                 # Скрипт сборки и запуска
├── scripts/
│   └── run_example_dpdk.sh  # Скрипт запуска теста
├── src/
│   └── main.c               # Модифицированный код DPDK
└── logs/                    # Директория для логов
```

## Зависимости в контейнере
```text
build-essential     # Компиляторы GCC, make, библиотеки C
meson               # Система сборки
ninja-build         # Ускоритель сборки
python3-full        # Python 3 и pip для скриптов DPDK
libnuma-dev         # Поддержка NUMA (Non-Uniform Memory Access)
pkg-config          # Конфигурация пакетов
libelf-dev          # Работа с ELF файлами (для DPDK сборки)
wget                # Загрузка архива DPDK
xz-utils            # Распаковка .tar.xz архива
pyelftools          # Обработка ELF файлов (через pip)
```
## Модификации main.c
Основные изменения:

1) Добавлена функция traffic_gen() - генерирует 1000 тестовых пакетов по 64 байта, заполняет случайными данными и отправляет через порт 0
2) Конечный счетчик пакетов - вместо бесконечного цикла обрабатывает 10,000 пакетов и автоматически завершает работу
3) Вызов генератора трафика - добавлен в main() перед lcore_main() для инициализации тестового трафика

## Ожидаемый вывод
```text
Port 0 MAC: 00 00 00 00 00 00
Port 1 MAC: 00 00 00 00 00 00

Core 0 forwarding packets. [output when processing 10000 packets]
Latency = 8164247372147 cycles  # Первое измерение (инициализация)
Latency = 66 cycles             # Реальные задержки
Latency = 78 cycles
...
Processed 10048 packets. Exiting.
```

## Docker команды
```bash
# Сборка образа
docker build -t dpdk-test .

# Запуск теста
docker run -it --rm dpdk-test /DPDK/scripts/run_example_dpdk.sh

# Интерактивный режим
docker run -it --rm dpdk-test bash
```
## Параметры DPDK
--no-huge           - без hugepages

--vdev=net_ring0/1  - виртуальные ring buffer устройства

-l 0-1              - использовать ядра 0 и 1

-m 512              - 512MB памяти
