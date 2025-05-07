aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 182399689800.dkr.ecr.eu-central-1.amazonaws.com
docker build -t car-rental/car-rental-service ../.
docker tag car-rental/car-rental-service:latest 182399689800.dkr.ecr.eu-central-1.amazonaws.com/car-rental/car-rental-service:latest
docker push 182399689800.dkr.ecr.eu-central-1.amazonaws.com/car-rental/car-rental-service:latest