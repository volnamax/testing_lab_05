# Используем официальный образ Python 3.10
FROM python:3.10

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем только файл зависимостей для кэширования слоя
COPY requirements.txt /app/

# Устанавливаем зависимости (сначала базовые, затем доп. библиотеки)
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir opentelemetry-api \
                                opentelemetry-sdk \
                                opentelemetry-exporter-jaeger \
                                prometheus_client \
                                behave

# Теперь копируем весь код (чтобы слои кешировались)
COPY . /app/

# Устанавливаем зависимости операционной системы
RUN apt-get update && apt-get install -y coreutils && rm -rf /var/lib/apt/lists/*

# Делаем `wait-for-it.sh` исполняемым
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# Открываем порт 8000
EXPOSE 8080

# Запускаем приложение
CMD ["python", "main.py"]
