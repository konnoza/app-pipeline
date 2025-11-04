# App Pipeline Repository

This repository contains the necessary components and configurations for a full-stack application, including its frontend, backend, and continuous integration/continuous deployment (CI/CD) pipelines for automated deployment.

## Project Structure

- `backend/`: Contains the Python backend application, its Dockerfile, and dependencies.
- `frontend/`: Contains the Node.js frontend application, its Dockerfile, and dependencies.
- `.github/workflows/`: Stores GitHub Actions workflows for CI/CD.
- `helm/`: Contains Helm charts for deploying the application to Kubernetes.
- `deploy/`: Contains environment-specific deployment configurations.

## CI/CD Pipelines

This repository utilizes GitHub Actions to automate the build, push, and deployment processes:

- `build-push-be.yaml`: Builds the backend Docker image and pushes it to a container registry.
- `build-push-fe.yaml`: Builds the frontend Docker image and pushes it to a container registry.
- `deploy-be-stg.yaml`: Deploys the backend application to the staging environment using Helm.
- `deploy-fe-stg.yaml`: Deploys the frontend application to the staging environment using Helm.

## How to Deploy the Project

To deploy this project, you will typically follow these steps:

1.  **Container Registry Access:** Ensure your CI/CD environment has access to push and pull Docker images from a container registry (e.g., Docker Hub, AWS ECR, Google Container Registry).
2.  **Kubernetes Cluster Access:** Ensure your CI/CD environment has access to a Kubernetes cluster where the application will be deployed.
3.  **GitHub Actions:** The deployment is automated via GitHub Actions. Pushing changes to the main branch (or a configured branch) will trigger the build, push, and deployment workflows.
    - The `build-push-be.yaml` and `build-push-fe.yaml` workflows will build and push the respective Docker images.
    - The `deploy-be-stg.yaml` and `deploy-fe-stg.yaml` workflows will then use the Helm charts in the `helm/` directory to deploy the applications to the staging environment.

### Manual Deployment (for development/testing)

For manual deployment or local testing, you can use Helm directly:

1.  **Build Docker Images:**
    ```bash
    docker build -t your-registry/frontend:latest ./frontend
    docker build -t your-registry/backend:latest ./backend
    ```
2.  **Push Docker Images:**
    ```bash
    docker push your-registry/frontend:latest
    docker push your-registry/backend:latest
    ```
3.  **Deploy with Helm:**
    Navigate to the `helm/` directory and run:
    ```bash
    helm upgrade --install <release-name> . -f ../deploy/stg-frontend-values.yaml --set frontend.image.repository=your-registry/frontend --set backend.image.repository=your-registry/backend
    ```
    Replace `<release-name>` with a desired name for your Helm release and `your-registry/frontend`, `your-registry/backend` with your actual image paths. You might need to adjust other values in `values.yaml` or provide them via `--set` flags based on your environment.
