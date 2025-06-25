# AWS Docker Build Configuration

이 디렉토리는 AWS 환경에서 애플리케이션을 Docker 이미지로 빌드하고 배포하기 위한 설정 파일을 포함합니다.

## 구성 파일

- `Dockerfile` : 앱 컨테이너 이미지를 빌드하기 위한 Dockerfile
- `buildspec.yml` : AWS CodeBuild에서 사용할 빌드 스펙 파일 (빌드 명령, 아티팩트 정의 등 포함)

## 목적

이 구성을 통해 AWS CodeBuild에서 자동으로 Docker 이미지를 빌드하고 ECR 등으로 푸시할 수 있습니다.