# ECS v2 URL Shortener

## Project Overview

This project is an **iteration of my previous ECS deployment**, where I improved the architecture, security and cost efficiency of the system.

The application is a containerised URL shortener running on **ECS Fargate**, deployed through a CI/CD pipeline using **GitHub Actions and AWS CodeDeploy**.

Users submit a long URL and receive a short code which redirects to the original destination.

Endpoints:

- GET `/healthz` – health check
- POST `/shorten` – generate a short URL
- GET `/{short}` – redirect to the original URL

<img width="706" height="111" alt="Image" src="https://github.com/user-attachments/assets/d403a691-2181-4285-bf02-14bbe4b405e9" />
<img width="541" height="86" alt="Image" src="https://github.com/user-attachments/assets/fbc72acc-700b-434e-b369-cf427388aca4" />

---

## Infrastructure

Infrastructure is provisioned using **Terraform** with remote state stored in S3 and DynamoDB state locking.

The architecture includes:

• ECS Fargate tasks running in private subnets
• Application Load Balancer with **WAF protection**
• **Route53 + ACM certificate** for HTTPS
• **DynamoDB** storing URL mappings using PAY_PER_REQUEST
• **VPC Endpoints** for private AWS service communication (no NAT gateways)
• **Secrets Manager** for storing environment variables securely
• **Least-privilege IAM roles** for application access

---

## CI/CD Pipeline

The project uses **GitHub Actions** for CI/CD.

Key features:

• Docker image build and push to **ECR**
• Authentication to AWS using **OIDC roles** (no long-lived credentials)
• Automatic ECS task definition update with the new image
• **CodeDeploy triggered for deployments**

---

## Deployment Strategy

Deployments use **blue/green deployments with CodeDeploy**.

Two target groups are used:

• Blue – current production version
• Green – new deployment version

Traffic is shifted using a **canary strategy**, gradually moving traffic to the new version.

If health checks fail, **automatic rollback** restores the previous version.

---

## Architecture Diagram

<img width="1898" height="1076" alt="Image" src="https://github.com/user-attachments/assets/c7c5c6b7-40a4-4517-99be-c64a73d40458" />

## Design Decisions

**VPC Endpoints instead of NAT Gateways**
Reduces infrastructure cost and keeps service communication inside the AWS network.

**WAF in front of ALB**
Filters HTTP/HTTPS requests and allows rate-based protection against request flooding.

**Secrets Manager for environment variables**
Prevents sensitive values from being hardcoded in the container image.

**Canary deployments**
Gradually shifts traffic to reduce risk during production releases.

---

## Demonstration

The following screenshots demonstrate the infrastructure and deployment working end-to-end.

### CodeDeploy Deployment
<img width="1919" height="1078" alt="Image" src="https://github.com/user-attachments/assets/bf6a00ae-0996-4a05-b218-7b4831a815f8" />

### CI Build Workflow
<img width="1886" height="824" alt="Image" src="https://github.com/user-attachments/assets/cd17f804-efff-416b-9bfb-c8e17170234e" />

### Terraform Apply
<img width="1910" height="1079" alt="Image" src="https://github.com/user-attachments/assets/3df2baf1-39d8-4068-a9ed-e957bd1f9a23" />

### Terraform Destroy
<img width="1911" height="1003" alt="Image" src="https://github.com/user-attachments/assets/be9c28e7-75c3-439e-a8b2-4523917eb99f" />



