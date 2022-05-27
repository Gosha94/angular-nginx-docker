### STAGE 1:BUILD ###

# FROM node:current-alpine as mobile_admin_build
FROM node:12.14-alpine AS mobile_admin_build

# Create a Virtual directory inside the docker image
WORKDIR /mobile-admin

# Copy files to virtual directory
# COPY package.json package-lock.json ./
# Run command in Virtual directory
RUN npm cache clean --force

# Copy files from local machine to virtual directory in docker image
COPY . .
RUN npm install
RUN npm run build --prod

### STAGE 2:RUN ###

# Defining nginx image to be used
FROM nginx:latest AS http_server

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copying compiled code and nginx config to different folder
# NOTE: This path may change according to your project's output folder 
COPY --from=mobile_admin_build /. /usr/share/nginx/html
COPY /nginx_config/nginx.conf  /etc/nginx/conf.d/default.conf

# Exposing a port, here it means that inside the container 
# the app will be using Port 80 while running
EXPOSE 80