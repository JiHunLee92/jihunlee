# GKE HPA Scaler (Scheduled Auto-Scaling Controller)

이 디렉토리는 GKE(Horizontal Pod Autoscaler)의 최소/최대 파드 수를 **지정된 시간에 자동으로 조정**하기 위한 스크립트와 Dockerfile을 포함합니다.  
GCP Cloud Scheduler와 Cloud Run을 이용하여, **예측 가능한 트래픽 증가 시간에 미리 리소스를 확장**할 수 있도록 구성되어 있습니다.

---

## 💡 주요 목적

- 트래픽이 집중되는 시간대(예: 이벤트 시작 전)에 맞춰 GKE 클러스터의 HPA 파라미터(`minReplicas`, `maxReplicas`)를 사전에 조정
- 기본 자동 스케일링보다 빠르게 대응하여 **사용자 요청 지연 최소화** 및 **장애 예방**
- GCP 서비스 조합으로 **서버리스한 운영**, 유지보수 최소화

---

## ⚙️ 아키텍처 구성

1. `main.py`: GKE 클러스터의 HPA 설정을 API 호출을 통해 조정
2. `Dockerfile`: Python 애플리케이션을 컨테이너화
3. `requirements.txt`: 필요한 라이브러리 정의 (`google-cloud-container`, `kubernetes`, 등)