# Docker Build Environments

이 디렉토리는 애플리케이션을 컨테이너 이미지로 빌드하기 위한 환경별(Docker + CI/CD) 설정 파일들을 포함하고 있습니다.  
각 클라우드 환경(AWS, GCP)에 맞는 Dockerfile과 해당 환경에서의 빌드 자동화 설정(yaml)이 포함되어 있습니다.

---

## 📁 디렉토리 구성

### 📁 aws/
- `Dockerfile` : 애플리케이션을 AWS 환경에 맞게 빌드하기 위한 Dockerfile
- `buildspec.yml` : AWS CodeBuild에서 해당 이미지를 자동 빌드하기 위한 빌드 스펙 파일
- 자세한 구성과 설명은 [`aws/README.md`](./aws/README.md) 참고

### 📁 gcp/
- `Dockerfile` : 애플리케이션을 GCP 환경에서 빌드하기 위한 Dockerfile
- `cloudbuild.yaml` : GCP Cloud Build에서 이미지를 빌드하고 Artifact Registry에 업로드하는 설정 파일
- 자세한 구성과 설명은 [`gcp/README.md`](./gcp/README.md) 참고

---

## ✅ 목적

- **CI/CD 환경별 Docker 이미지 빌드 자동화**
- AWS CodeBuild 또는 GCP Cloud Build를 통한 배포 파이프라인 통합
- 클라우드 환경 간의 빌드 설정 차이를 구분하여 관리