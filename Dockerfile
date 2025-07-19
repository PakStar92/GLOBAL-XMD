FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    git \
    curl \
    sudo \
    bash \
    ffmpeg \
    webp \
    imagemagick \
    python3 \
    ca-certificates \
    gnupg \
    software-properties-common

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn supervisor sharp

RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

COPY package.json ./
RUN npm install
COPY . .

EXPOSE 5000

CMD ["npm", "start"]
