FROM node:16 as build

WORKDIR /app
COPY package.json ./
RUN npm i
COPY ./ ./

ENV NODE_ENV=production

RUN npm run build
RUN npm prune --production

FROM node:16-alpine

COPY --from=build /app/node_modules node_modules
COPY --from=build /app/package.json .
COPY --from=build /app/dist dist

ENTRYPOINT [ "npm" ]
CMD [ "run", "start:prod" ]
