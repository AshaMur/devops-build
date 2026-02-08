# Stage 1: Build the app
FROM node:16-alpine AS builder
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source and build
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy build output from builder stage into Nginx html directory
COPY --from=builder /app/build .

# Optional: replace default Nginx config if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
