  
# This Docker file is for building this project on Codeship Pro
# https://documentation.codeship.com/pro/languages-frameworks/nodejs/

# use Cypress provided image with all dependencies included
# FROM cypress/base:10
FROM cypress/included:4.8.0
RUN node --version
RUN npm --version
RUN pwd
RUN ls -l
WORKDIR /e2e
# copy our test application
COPY package.json ./
# COPY app ./app
# COPY serve.json ./
# copy Cypress tests
COPY cypress.json ./
COPY cypress ./cypress
RUN pwd
RUN ls -l


# avoid many lines of progress bars during install
# https://github.com/cypress-io/cypress/issues/1243
ENV CI=1

# install NPM dependencies and Cypress binary
RUN npm install
# check if the binary was installed successfully
# RUN $(npm bin)/cypress verify
# run tests
# RUN $(npm bin)/cypress run