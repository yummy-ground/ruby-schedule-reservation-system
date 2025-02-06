# Schedule Reservation System API
고객과 어드민이 각각의 필요에 맞게 시험 일정 예약을 처리할 수 있는 ‘**일정 예약 시스템 API**’입니다.

<br/>

## Tech Stack
- Language : Ruby 3.2.2
- Framework : Rails 8.0.1
- Database : PostgreSQL
- Documentation : Swagger (`rswag 2.16.0`)

<br/> 

## Feature
본 어플리케이션에서 API를 통해 제공하는 기능들입니다.

### 예약 조회
- **User**
  - “예약 신청 가능 시간 & 인원” 조회
  - “본인 등록 예약”만 조회
- **Admin**
  - 고객이 등록한 모든 예약 조회

### 예약 신청
- 시험 시작 3일 전까지 신청 가능
- 동 시간대 최대 50,000명까지만 예약 가능
    - 확정되지 않은 예약은 50,000명 제한에 포함되지 않음
      → 즉, 실제로는 특정 시간대에 50,000명이 넘는 예약 인원이 존재할 수 있음 (확정 처리 안된 예약들)
    - ex. 04/15 14:00 ~ 16:00 - 30,000명 예약 확정 → 20,000명 이하인 추가 예약 신청 가능

### 예약 확정
> **흐름** : 예약 신청(`User`) → 확인 확정(`Admin`) → 시험 운영 일정 반영

- 확정되지 않은 예약 → 최대 인원 수 계산 포함 X
- **Admin** : 모든 고객 예약 확정 가능

### 예약 수정
- **User** : “예약 확정 전” → 본인 예약 수정 가능
- **Admin** : 모든 고객 예약 수정 가능

### 예약 삭제
- **User** : 확정 전에 본인 예약 삭제 가능
- **Admin** : 모든 고객 예약 삭제 가능

<br/>

## Exception
- **예약 신청**
  - User : 50,000명 초과된 시간대 신청한 경우
  - User : 현재 신청 날짜가 시험 시작일 기준 3일 이내일 경우
- **예약 확정**
  - Admin : 확정하고자 하는 시험의 인원 수와 이미 확정된 시간대의 인원 수의 합이 50,000명을 초과할 경우
- **예약 수정**
  - User : 확정된 예약에 대해 수정을 시도한 경우
  - User : 본인이 예약하지 않은 일정에 대해 수정을 시도한 경우
- **예약 삭제**
  - User : 확정된 예약에 대해 삭제를 시도한 경우
  - User : 본인이 예약하지 않은 일정에 대해 수정을 시도한 경우

<br/>

## Domain
### Users (`users`)
| Column | Type     | Description        |
|:-------|:---------|:-------------------|
| `id`   | `number` | **Required**. (PK) |
| `role` | `string` | **Required**. 권한   |    

<br/>

### Schedules (`schedules`)
| Column           | Type        | Description         |
|:-----------------|:------------|:--------------------|
| `id`             | `number`    | **Required**. (PK)  |
| `user_id`        | `number`    | **Required**. (FK)  |
| `name`           | `number`    | **Required**. 예약명   |
| `personnel`      | `number`    | **Required**. 인원 수  |  
| `start_datetime` | `timestamp` | **Required**. 시작 일시 |  
| `end_datetime`   | `timestamp` | **Required**. 종료 일시 | 
| `is_confirm`     | `boolean`   | **Required**. 확정 여부 |  


<br/>

## Run Locally
본 프로젝트를 로컬 환경에서 실행하기 위한 환경 설정 및 실행 방법입니다.

### Before Run
- **Local**
  - Ruby 3.2.2 설치 필요
  - Bundler 설치 필요
  - Rails 8.0.1 설치 필요
    - Node.js & Yarn 설치 필요
  - PostgreSQL 설치 필요
- **Docker** 
  - **Docker** 설치 필요
  - (Optional) **Compose** 사용 희망 시, 추가 설치 필요

<br/>

### Run
> 1. 실행을 위해 필요한 환경변수(`.env`)는 별도 공유가 필요합니다.
> 2. 요청 시, 주어진 JWT를 사용해야 합니다.
> 3. Docker로 실행할 경우, Container 로그를 통해 JWT를 확인해야 합니다.
- **Docker 미사용** 시
  - 기본적으로 Local 환경에 PostgreSQL이 실행 중이어야 합니다.
  ```shell
  bundle install

  dotenv rails s -p 8080
  ```
<br/>

- **Docker 사용** 시 (Docker Compose ❌)
  - 기존 Local에 동일한 이름의 컨테이너가 있는지 확인이 필요합니다.
  - `.env` 파일을 최대한 프로젝트 root에 위치시켜주세요.
    - 만약 `.env` 파일 path는 해당 파일을 다운로드 받은 경로를 입력해야 합니다.
  - 단일 어플리케이션을 위한 단일 데이터베이스 컨테이너이기 때문에 `--link`를 사용합니다.
  ```shell
  docker volume create postgres_data
  docker network create app_network
  # 변수 내부 내용은 직접 입력해주세요.
  # DB Container
  docker run -d --name app_db --network app_network \
      -e POSTGRES_USER=${DB_USERNAME} \ 
      -e POSTGRES_PASSWORD=${DB_PASSWORD} \
      -e POSTGRES_DB=schedule_reservation_system \
      -p 5432:5432 \
      -v postgres_data:/var/lib/postgresql/data \
      postgres
  
  # Ruby API Application Container
  # 프로젝트 root 위치에 .env 파일이 있다면 해당 파라미터는 생략해도 괜찮습니다.
  docker build --build-args ENV_FILE_PATH=${ENV_FILE_PATH} -t app .
  docker run -d --name app --network app_network \
      -e DB_NAME=schedule_reservation_system \
      -e DB_USERNAME=${DB_USERNAME} \
      -e DB_PASSWORD=${DB_PASSWORD} \
      -e DB_HOST=app_db \
      -p 8080:8080 \
      -w /app \
      app
  ```
- **Docker 사용** 시 (Docker Compose ✅)
  ```shell
  # 프로젝트 root 위치에 .env 파일이 있다면 ENV_FILE_PATH 파라미터는 생략해도 괜찮습니다.
  DB_USERNAME=${DB_USERNAME} DB_PASSWORD=${DB_PASSWORD} ENV_FILE_PATH={ENV_FILE_PATH} docker compose up -d --build
  ```

<br/>

## API Documentation
Swagger를 통해 API 문서를 제공합니다.<br/>
위 [Run Locally](#run-locally)를 참고하여 로컬 환경에서 어플리케이션을 실행시킨 후, [http://localhost:8080/api-docs](http://localhost:8080/api-docs)에 접속하면 확인할 수 있습니다.

<br/>

## Additional
> 요청자 식별을 위한 JWT 이용 방식

rails 어플리케이션 시 실행되는 콘솔 로그를 확인해주세요.
```test
dotenv rails s -p 8080

=> Booting Puma
=> Rails 8.0.1 application starting in development 
=> Run `bin/rails server --help` for more startup options

...
> Schedule dummy data insert succeeded

> User (user_id 1) JWT : eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwicm9sZSI6InVzZXIiLCJpYXQiOjE3Mzg2NjQxNDgsImV4cCI6MTczODc1MDU0OH0.0yzi1eRngKOSf8JbeWzo8csSk3vsaCF8kIefspiQ4zE
> Admin (user_id 2) JWT : eyJhbGciOiJIUzI1NiJ9.eyJpZCI6Miwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzM4NjY0MTQ4LCJleHAiOjE3Mzg3NTA1NDh9.SBmuNttSs-YGJOc5TZnipmz-cJctwaryXnxVKJ-KSz4
Puma starting in single mode...
* Puma version: 6.6.0 ("Return to Forever")
...
```

<br/>

> API 문서를 Swagger로 채택한 이유 + `rswag` 라이브러리를 채택한 이유

어플리케이션 구현 내용에 따라 자동 반영되어 정보 정확성과 편의성 측면에서 이점이 있으며 endpoint를 통한 쉬운 접근성을 근거로 채택했습니다.

라이브러리의 경우, `Rswag` 와 `Grape-Swagger-Rails` 중 `Rswag` 을 채택했습니다.

- Grape를 Rails 환경에서 통합하여 사용할 계획이라면 `grape-swagger-rails`가 적합함.
- Rails routes와 통합되므로 문서화가 용이함.
- Rails 컨트롤러를 사용하여 API
- 자동으로 Swagger 문서를 생성하고, RSpec 기반 테스트와 연동할 수 있어서 유지보수가 편리함.

<br/>

> 에약 시간대 정책

요구사항 명세서 내 예시를 참고하여 "시 단위"(Hour)와 "분 단위"(Minute) 중 "**시 단위**"(Hour)를 채택했습니다.<br/>

<br/>

> 예약 가능 일정 조회 기준 설정

요청 파라미터를 통해 "월(Month)"을 기준으로 "해당 월에 가능한 일정"을 조회할 수 있도록 했습니다.<br/>
(요청 파라미터가 존재하지 않을 경우, 조회 시점을 기준으로 월 데이터가 적용됩니다.)

<br/>

> `.gitignore`

[gitignore.io](https://www.toptal.com/developers/gitignore) - "Ruby", "Rails", "RubyMine" 항목을 적용하여 생성했습니다.