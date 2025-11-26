#!/bin/bash

# Список сайтов для мониторинга
sites=("https://google.com" "https://example.com" "https://github.com")

# Время отправки отчёта (по умолчанию 09:00, если переменная не задана)
REPORT_TIME=${REPORT_TIME:-"09:00"}

# Если файла ещё нет — создаём заголовок CSV
if [ ! -f /data/status.csv ]; then
    echo "timestamp,site,status" > /data/status.csv
fi

# Логируем старт
echo "monitor.sh started at $(date), report time set to $REPORT_TIME" >> /data/debug.log

# Переменная для отслеживания последней отправки
last_sent_day=""

# Основной цикл
while true; do
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Проверка сайтов
    for site in "${sites[@]}"; do
        if curl -s --head --request GET "$site" | grep "200 OK" > /dev/null; then
            status="up"
        else
            status="down"
        fi

        echo "$timestamp,$site,$status" >> /data/status.csv
        echo "$timestamp,$site,$status" >> /data/debug.log
    done

    # Проверяем: если текущее время совпадает с REPORT_TIME и отчёт ещё не отправлялся сегодня
    current_day=$(date +"%Y-%m-%d")
    current_time=$(date +"%H:%M")

    if [ "$current_time" == "$REPORT_TIME" ] && [ "$current_day" != "$last_sent_day" ]; then
        echo "Sending daily report at $timestamp" >> /data/debug.log
        python3 /plot_and_send.py
        last_sent_day="$current_day"
    fi

    sleep 60
done
