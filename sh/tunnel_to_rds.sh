#!/bin/bash

# Prerequisites:
# - bastion host is running
# - rds instance is running

RDS_ENDPOINT="car-rental.chkc4y0ew55u.eu-central-1.rds.amazonaws.com"
BASTION_HOST="3.123.19.5"

if [ -z "$RDS_ENDPOINT" ] || [ -z "$BASTION_HOST" ]; then
    exit 1
fi

# Create SSH tunnel
ssh -i ~/.ssh/bastion-key -NL 5432:$RDS_ENDPOINT:5432 ubuntu@$BASTION_HOST