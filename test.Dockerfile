# Dev Dockerfile

# Production image as base
FROM demo-app as BASE

# Copy test files
COPY tests tests

# Set environment variable
ENV NODE_ENV dev

# Install app dependencies and test framework
RUN npm install

# Run tests, instead of the application
CMD [ "npm", "test" ]