# build phase to build a production ready app
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
# run npm run build to generate a build folder with all the files we need to serve our app to browser
# we no longer need all the node_modules dependencies cause they're all packages into js file in build folder
RUN npm run build

# no tag here cause it'll ignore previous phase so that we only take the things we need from previous builder phase
FROM nginx
# this command does nothing in local machine development environment
# (however, elastic beanstalk will use this command to expose port 80 on our container for incoming traffic)
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html
# copy to html folder in nginx as that is the default folder where they'll serve webpages
