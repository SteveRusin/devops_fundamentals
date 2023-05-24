#!/bin/bash

npm run lint
npm run test
npm run audit

CLIENT_REMOTE_DIR=/var/www/client
SSH_ALIAS=sshuser

if ssh $SSH_ALIAS "[ ! -d $1 ]"; then
  echo "Creating: $1"
  ssh -t $SSH_ALIAS "sudo bash -c 'mkdir -p $1 && chown -R sshuser: $1'"
else
  echo "Clearing: $1"
  ssh $SSH_ALIAS "sudo -S rm -r $1/*"
fi

npm install

if [ "$ENV_CONFIGURATION" = "production" ]; then
  npm run build -- --configuration=production
else
  npm run build
fi

export ENV_CONFIGURATION="${ENV_CONFIGURATION:-development}"

scp -Cr dist/* $SSH_ALIAS:$CLIENT_REMOTE_DIR

echo "Done"
