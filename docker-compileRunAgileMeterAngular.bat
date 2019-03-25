docker docker build -f everisapi.API/Dockerfile_Angular -t "agilemeter_angular" .
docker run --name agilemeter_angular -p 4200:4200 agilemeter_angular