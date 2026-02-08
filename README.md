# Pantree
A full-stack recipe and pantry management app built with **React Native**, **AWS**, and **PostgreSQL**.

Pantree lets users securely sign in, store recipes, and manage their pantry using a serverless backend. This project is also a learning exploration of cloud architecture.

## Learning Goals

This project focuses on:

* real-world cloud architecture
* clean separation of auth vs app data
* idempotent backend design
* infrastructure-as-code
* scalable patterns (not shortcuts)
* mobile app development with React Native

## Architecture Overview
**Frontend**
- React Native (Expo)
- Expo Router
- AWS Amplify Auth (Cognito)

**Backend**
- AWS API Gateway (HTTP API, v2)
- AWS Lambda (Node.js / TypeScript)
- AWS Cognito (JWT auth)
- Amazon RDS (PostgreSQL)
- AWS Secrets Manager

**Infrastructure**
- Terraform (all AWS resources)
- Bash + Node scripts for deployment

## Project Structure

```
pantree/
├─ app/                 # React Native app (Expo Router)
├─ components/          # Shared UI components
├─ assets/              # Images, fonts, etc.
├─ services/            # Lambda functions (one folder per service)
│  └─ me/
│     ├─ handler.ts
│     └─ dist/
├─ schema/              # SQL schema + DB helpers
├─ infra/               # Terraform infrastructure
├─ scripts/             # Deployment / helper scripts
│  ├─ deploy-backend.sh
│  ├─ terraform-install.sh
│  ├─ write-env.sh
│  └─ zip-lambdas.mjs
└─ README.md
```

## Getting Started

### Prerequisites
- Node.js (18+ recommended)
- npm or yarn
- AWS account
- AWS CLI installed
- Bash (macOS, Linux, or Git Bash on Windows)

## AWS Configuration

Before anything else, configure AWS credentials:

```bash
aws configure
````

You’ll need:

* AWS Access Key ID
* AWS Secret Access Key
* Default region (e.g. `us-east-1`)
* Output format (`json`)

> You must have permission to create IAM, Lambda, API Gateway, RDS, Cognito, and VPC resources.

## Installing Terraform

If you don’t have Terraform installed:

```bash
bash scripts/terraform-install.sh
```

Verify:

```bash
terraform -v
```

## Backend Setup (AWS)

From the project root:

```bash
npm run deploy:backend
```

This will:

* build and zip all lambda handlers
* run `terraform init`
* apply all infrastructure
* create Cognito, RDS, API Gateway, Lambdas
* write environment variables to `.env`
* create an initial test user

## Frontend Setup

From the project root:

```bash
npm install
npm run dev
```

Make sure `.env` includes:

```env
EXPO_PUBLIC_API_URL=<api-base-url>
EXPO_PUBLIC_USER_POOL_ID=<cognito-pool-id>
EXPO_PUBLIC_USER_POOL_CLIENT_ID=<client-id>
```

## Teardown (Destroy AWS Resources)

**This deletes all AWS resources** created by Terraform.

From the project root:

```bash
npm run destroy
```

## Planned Features

* Recipe CRUD (create, edit, delete)
* Collections of recipes
* Pantry tracking
* Image uploads (S3)
* Search and filtering
* Offline-friendly caching

## Notes

### Authentication Flow
1. User signs in via Cognito (Amplify)
2. App receives JWT tokens
3. App calls `GET /me`
4. API Gateway validates JWT
5. Lambda upserts user into database
6. Backend returns user info

This `/me` endpoint acts as a **bootstrap** for backend identity.