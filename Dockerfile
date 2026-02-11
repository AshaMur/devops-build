# Stage: Serve prebuilt React app
FROM nginx:alpine

# Set working directory to Nginx's default HTML folder
WORKDIR /usr/share/nginx/html

# Copy the prebuilt React app (from build/ folder) into container
COPY build/ .

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
