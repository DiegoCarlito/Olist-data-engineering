FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y openjdk-21-jre-headless procps && \
    apt-get clean

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["tail", "-f", "/dev/null"]
