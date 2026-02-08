FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/build /usr/share/nginx/html
