# GCP Docker Build Configuration

이 디렉토리는 GCP 환경에서 앱을 Docker 이미지로 빌드하고 배포하기 위한 설정 파일을 포함합니다.

## 구성 파일

- `Dockerfile` : 앱 컨테이너 이미지를 위한 Dockerfile
- `cloudbuild.yaml` : GCP Cloud Build에서 사용하는 빌드 파이프라인 정의 파일

## 목적

GCP Cloud Build를 사용하여 CI/CD 파이프라인 내에서 Docker 이미지를 빌드하고 Container Registry 또는 Artifact Registry로 푸시할 수 있도록 구성되어 있습니다.
