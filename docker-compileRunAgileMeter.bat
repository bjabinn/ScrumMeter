docker build -t "agilemeter" ./everisapi.API
docker run --name agilemeter -p 80:60406 agilemeter