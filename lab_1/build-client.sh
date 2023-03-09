#! /usr/bin/env bash -xe

path_to_repo=/Users/Stepan_Sendun/Desktop/mentoring/devops_fundamentals/lab_1/shop-angular-cloudfront/


cd $path_to_repo

npm ci 
npm run build -- --configuration production

if [[ -f ./dist/client-app.zip ]] then
    rm -f ./dist/client-app.zip
fi
zip -r client-app.zip ./dist
mv client-app.zip ./dist
