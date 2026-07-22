# Use a slim Node.js base image to keep things efficient
FROM node:20-slim

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package files first to leverage Docker's caching layer for dependencies
COPY package*.json ./

# Install only production dependencies
RUN npm install --omit=dev

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Define the environment variable fallback
ENV PORT=5000

# Run the app
CMD ["node", "server.js"]