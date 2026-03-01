FROM node:20-alpine

RUN apk add --no-cache git

WORKDIR /app

RUN git clone https://github.com/genieacs/genieacs.git . \
    && git checkout v1.2.13 \
    && npm install \
    && npm run compile

EXPOSE 3000 7547 7557 7567

CMD ["npm", "run", "start-all"]
