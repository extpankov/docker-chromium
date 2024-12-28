FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget gnupg libnss3 libxss1 libgbm-dev fonts-liberation \
    libasound2 libx11-xcb1 libxcb1 libxcomposite1 libxdamage1 \
    libc6 libxrandr2 libxi6 libxtst6 libatk1.0-0 libgtk-3-0 \
    libicu-dev libdrm2 libxkbcommon0 libvulkan1 xdg-utils \
    xvfb unzip ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

RUN wget -O /tmp/ungoogled_chromium.zip http://download.extpankov.ru/ungoogled_chromium.zip && \
    unzip /tmp/ungoogled_chromium.zip -d /usr/lib/ && \
    rm /tmp/ungoogled_chromium.zip

RUN chmod +x /usr/lib/ungoogled-chromium/chrome-wrapper && \
    chmod +x /usr/lib/ungoogled-chromium/chromedriver && \
    ln -s /usr/lib/ungoogled-chromium/chrome-wrapper /usr/bin/chromium && \
    ln -s /usr/lib/ungoogled-chromium/chromedriver /usr/bin/chromedriver

ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

COPY . /app/


# Команда на выполнение по умолчанию
# CMD ["python", "main.py"]
