# LJH-History

# DevOps Projects Repository

이 저장소는 인프라 구성 자동화, 컨테이너 환경 설정, Kubernetes 운영, 스크립트 기반 자동화, 실제 앱 코드 등을 포함한 DevOps 실습 및 업무 결과물을 정리한 저장소입니다.  
모든 디렉토리는 기능 단위로 구성되어 있으며, 아래 내용을 참고하세요.

---

## 🔧 infra/

### 📁 ansible/
- 서버 환경 세팅 자동화를 위한 Ansible 플레이북(yaml) 모음
- 예: 패키지 설치, 사용자 생성, 서비스 구성 등

### 📁 k8s-manifests/
- Kubernetes 환경에 배포하기 위한 manifest 파일들
- Docker 이미지 기반으로 실행될 앱 정의 포함

### 📁 terraform/
- **aws/**: AWS 인프라를 구성하기 위한 Terraform 코드
- **gcp/**: GCP 리소스 구성을 위한 Terraform 코드

---

## 💻 app/

### 📁 application/
- 실제 서비스(Lambda 등)에 적용한 코드와 실험용 기능을 포함하는 애플리케이션 코드 저장소입니다.
- 테스트와 운영 목적의 코드가 혼합되어 있으며, 일부 모듈은 독립 실행 또는 배포가 가능합니다.

### 📁 docker/
- 애플리케이션 빌드를 위한 Dockerfile 모음

### 📁 scripts/
- 업무 중 반복 작업을 자동화하기 위한 Bash/Python 스크립트
- 예: 로그 수집, 배포 자동화, 알림 전송 등

---

## 📎 기타 안내

- 각 디렉토리는 README 또는 주석을 통해 목적과 사용법을 간단히 명시해 두었습니다.
- 본 저장소는 업무 경험과 DevOps 역량을 보여주기 위한 개인 프로젝트 기록용입니다.

