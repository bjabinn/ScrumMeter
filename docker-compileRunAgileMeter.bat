docker build -t "agilemeter" ./everisapi.API
docker run --name agilemeter --link autodumperagile:database -p 60406:60406 agilemeter