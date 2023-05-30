# The base image is a NodeJS image running on the alpine linux distribution.
FROM node:18.12-alpine3.17 as build
# We will use this as our home directory.
WORKDIR /app

# Copy npm dependency files.
COPY package.json package-lock.json ./

# Install our npm dependencies.
RUN npm ci

# Copy the rest ouf our source code and configuration.
COPY tsconfig.json ./
COPY public ./public
COPY src ./src

# Transpile our applications into static files.
RUN npm run build

# The static files will be served by the Nginx Web server.
FROM nginx:1.23.3-alpine

# Expose port 80, this is not required but good for documentation purposes.
EXPOSE 80

# Copy the static files from our earlier build into the nginx image.
COPY --from=build /app/build /usr/share/nginx/html