#! /usr/bin/env bash -xe

path_to_repo=/Users/Stepan_Sendun/Desktop/mentoring/devops_fundamentals/lab_1/shop-angular-cloudfront/


cd $path_to_repo


npm audit
npm run lint
npm run test
