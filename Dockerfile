FROM quay.io/qasimtech/global-botz:latest
RUN git clone https://github.com/GlobalTechInfo/GLOBAL-XMD /root/GLOBAL-XMD && \
    rm -rf /root/GLOBAL-XMD/.git
WORKDIR /root/GLOBAL-XMD
RUN rm -rf node_modules
RUN npm install && \
    npm cache clean --force
EXPOSE 5000
CMD ["npm", "start"]
