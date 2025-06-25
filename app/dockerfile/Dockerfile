ARG NODE_VERSION=18.16.1
FROM node:$NODE_VERSION

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

RUN apt update && \
    apt install -y vim curl net-tools

COPY package*.json $APP_HOME/

RUN npm install 

COPY . $APP_HOME/

ENV BEANSTALK_ENV test-env
ENV EXTRA_ENV development
ENV NODE_ENV development
ENV NPM_CONFIG_UNSAFE_PERM true


RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "start"]


