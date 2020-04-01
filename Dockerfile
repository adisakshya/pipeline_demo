# Dockerfile

# Base
FROM node:latest as BASE

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY ./app/package*.json ./

RUN npm install

# Bundle app source
COPY ./app .

# Expose port
EXPOSE 3000
CMD [ "npm", "start", "--host", "0.0.0.0" ]