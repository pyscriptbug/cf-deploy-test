set -e
set -x

CI_PROJECT_NAME=container-service-1
SERVICE_NAME=container-service-1
PORT=3000

# Get the uploaded image (its different every time)
IMAGE_TAG=$(aws lightsail get-container-images --service ${CI_PROJECT_NAME} | jq -r .containerImages[0].image)

# Construct JSON for the --containers argument
CONTAINERS_JSON=$(
  cat <<EOF
{
  "$SERVICE_NAME": {
    "image": "$IMAGE_TAG",
    "ports": {
      "$PORT": "HTTP"
    },
    "environment": {
      "AWS_ACCESS_KEY_ID": "$AWS_ACCESS_KEY_ID",
      "AWS_SECRET_ACCESS_KEY":"$AWS_SECRET_ACCESS_KEY",
    }
  }
}
EOF
)
# Construct JSON for the --public-endpoint argument
PUBLIC_ENDPOINT_JSON=$(
  cat <<EOF
{
  "containerName": "$SERVICE_NAME",
  "containerPort": $PORT,
  "healthCheck": {
    "path": "/"
  }
}
EOF
)
echo "Deploying to Lightsail $SERVICE_NAME"
# Create a deployment with the uploaded docker image
aws lightsail create-container-service-deployment \
  --service-name $SERVICE_NAME \
  --containers "$CONTAINERS_JSON" \
  --public-endpoint "$PUBLIC_ENDPOINT_JSON"
