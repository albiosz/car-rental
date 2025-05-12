aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 182399689800.dkr.ecr.eu-central-1.amazonaws.com
docker build -t car-rental/currency-converter ../.
docker tag car-rental/currency-converter:latest 182399689800.dkr.ecr.eu-central-1.amazonaws.com/car-rental/currency-converter:latest
docker push 182399689800.dkr.ecr.eu-central-1.amazonaws.com/car-rental/currency-converter:latest