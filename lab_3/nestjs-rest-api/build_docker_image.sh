#! /usr/bin/env bash

docker build -t nest-js-app .

HASH=$(git rev-parse HEAD)
HASH_SHORT=${HASH:0:6}

docker tag nest-js-app localhost:6000/$HASH_SHORT
docker push localhost:6000/$HASH_SHORT
