# debug linux problems, because docker sets up the volume as root user
docker exec -it expertgrid-app-1 chown -R $(id -u):$(id -g) /expertgrid 
