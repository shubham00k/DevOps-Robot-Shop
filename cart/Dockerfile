
#######STAGE 1: Build the application#######
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=production

COPY . . 

###### Stage 2: Run the application#######
FROM gcr.io/distroless/nodejs20-debian12 AS runtime

WORKDIR /app

COPY --from=builder /app /app/

USER 10001

EXPOSE 8080

CMD ["server.js"] 