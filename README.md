############# CONFIG Replica Set #################
rs.initiate(
  {
    _id: "mongors1conf",
    configsvr: true,
    members: [
      { _id : 0, host : "mongocfg1" },
      { _id : 1, host : "mongocfg2" },
      { _id : 2, host : "mongocfg3" }
    ]
  }
)

rs.status()

docker exec -it mongocfg1 bash -c "echo 'rs.status()' | mongo"

############## SHARD 1 Replica Set ################
rs.initiate(
  {
    _id: "mongors1",
    members: [
      { _id : 0, host : "mongors1n1" },
      { _id : 1, host : "mongors1n2" },
      { _id : 2, host : "mongors1n3" }
    ]
  }
)

rs.status()

docker exec -it mongors1 bash -c "echo 'rs.status()' | mongo"

############### SHARD 2 Replica Set ###############
rs.initiate(
  {
    _id: "mongors2",
    members: [
      { _id : 0, host : "mongors2n1" },
      { _id : 1, host : "mongors2n2" },
      { _id : 2, host : "mongors2n3" }
    ]
  }
)

rs.status()

docker exec -it mongors2 bash -c "echo 'rs.status()' | mongo"
##################################################
############### Mongos Routers ###################
docker exec -it mongos1 bash -c "echo 'sh.addShard(\"mongors1/mongors1n1\")' | mongo "
docker exec -it mongos1 bash -c "echo 'sh.addShard(\"mongors2/mongors2n1\")' | mongo "
# Need To Confirm If eg. mongors2n1 were down, The replica Set can replace this node instead !!!!!!
docker exec -it mongos1 bash -c "echo 'sh.status()' | mongo "
###################################################
Note! MongoDB mongos instances route queries and write operations to shards in a sharded cluster. mongos provide the only interface to a sharded cluster from the perspective of applications. Applications never connect or communicate directly with the shards.


#################################################
#
#
#Create Database and Shard it's collisions 
docker exec -it mongors1n1 bash -c "echo 'use someDb' | mongo"
docker exec -it mongos1 bash -c "echo 'sh.enableSharding(\"someDb\")' | mongo "
docker exec -it mongors1n1 bash -c "echo 'db.createCollection(\"someDb.someCollection\")' | mongo "

docker exec -it mongos1 bash -c "echo 'sh.shardCollection(\"someDb.someCollection\", {\"someField\" : \"hashed\"})' | mongo "
