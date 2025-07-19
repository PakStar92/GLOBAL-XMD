FROM ubuntu:24.04

# Install curl and dependencies
RUN apt-get update && apt-get install -y curl gnupg

# Add Node.js 20.x and install node + yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global yarn

# Install additional system packages
RUN apt-get update && apt-get install -y \
    ffmpeg \
    imagemagick \
    webp \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package.json and install deps
COPY package.json .
RUN npm install

# Copy app source code
COPY . .

# Expose desired port
EXPOSE 5000

# Start app when container starts
CMD ["npm", "start"]
