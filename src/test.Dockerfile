# Dev Dockerfile

# Production image as base
ARG PRODUCTION_IMAGE_TAG=0
FROM adisakshya/express:$PRODUCTION_IMAGE_TAG as BASE

# Copy test files
COPY ./src/tests tests

# Set environment variable
ENV NODE_ENV dev

# Install app dependencies and test framework
RUN npm install

# Run tests, instead of the application
CMD [ "npm", "test" ]