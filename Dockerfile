
FROM node:lts-buster
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
         && apt-get install -y nodejs \
         && npm install --global yarn

RUN apt-get install -y \
  ffmpeg \
  imagemagick \
  webp && \
  apt-get upgrade -y && \
  rm -rf /var/lib/apt/lists/*

COPY package.json .

RUN yarn install

COPY . .

EXPOSE 5000

RUN yarn start
