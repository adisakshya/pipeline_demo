# Production Dockerfile

# Base Image
FROM node:latest as BASE

# Licence label
LABEL licence="MIT"

# Create app directory
WORKDIR /usr/src/app

# Set environment variable
ENV NODE_ENV production

# Install app dependencies
COPY ./src/package*.json ./

RUN npm update

# Bundle app source
COPY ./src ./

# Start the application
# when running the container
CMD [ "npm", "start", "--host", "0.0.0.0" ]