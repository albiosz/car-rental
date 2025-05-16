#!/bin/bash

# Prerequisites:
# - bastion host is running
# - internal ALB is running
# - currency converter is running

INTERNAL_ALB_HOST="internal-car-rental-internal-alb-2045153271.eu-central-1.elb.amazonaws.com"
BASTION_HOST="3.123.19.5"

# Validate required parameters
if [ -z "$INTERNAL_ALB_HOST" ] || [ -z "$BASTION_HOST" ]; then
    exit 1
fi

# Create SSH tunnel
ssh -i ~/.ssh/bastion-key -NL 8080:$INTERNAL_ALB_HOST:8080 ubuntu@$BASTION_HOST