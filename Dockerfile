FROM ubuntu

# Install MongoDB.
RUN \
  apt-get update && \
  apt-get install apt-utils && \
  apt-get install -y wget dirmngr gnupg apt-transport-https ca-certificates software-properties-common && \
RUN  wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - 
RUN  add-apt-repository 'deb [arch=amd64] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse' 
RUN  apt-get install mongodb-org
# Define mountable directories.
VOLUME ["/data/db"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mongod"]

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017
