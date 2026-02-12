#multi stage production

# 1:builder stage 

# choose a base image:
FROM node:18-alpine AS build
#directory I'll be using in the container:
WORKDIR /app
#Copy files u need to install yarn
COPY package*.json yarn.lock ./
# install yarn
RUN yarn install
#copy all files from current directory  to container 
COPY . ./
# run yarn (the -y autoconfirms yes for the broswerlist update) and this puts the files into static files
RUN yarn build -y


#2 runtime stage
FROM node:18-alpine AS production 
# add non root user called nonroot to a group called appgroup
RUN addgroup -S appgroup && adduser -S nonroot -G appgroup
WORKDIR /app
#copy files from build stage to producution and make it go into the ./build folder
COPY --from=build /app/build ./build
#make ownership to non root user to read the static files (-R means all files in this folder)
RUN chown -R nonroot:appgroup /app
# Install serve command for yarn package manager
RUN yarn global add serve
#change user to nonroot
USER nonroot
#this is the port serve uses
EXPOSE 3000
# using serve to host react, -n means no clipboard needed,-s SPA mode, and build is the dir where the static files are)
CMD ["serve", "-n", "-s", "build"]