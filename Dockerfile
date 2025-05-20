FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install -g http-server
EXPOSE 8083
CMD ["http-server", "-p", "8083"]