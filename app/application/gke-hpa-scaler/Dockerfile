FROM python:3.9

# kubectl 설치
RUN apt-get update && apt-get install -y curl && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && mv kubectl /usr/local/bin/

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Gunicorn 실행 (4개의 워커 프로세스 사용)
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "main:app"]