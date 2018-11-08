# Build runtime image
FROM microsoft/dotnet:latest
ENV ASPNETCORE_ENVIRONMENT Development
   ENV http_proxy http://10.0.8.102:8080
   ENV https_proxy http://10.0.8.102:8080
RUN mkdir -p /app
WORKDIR /app
COPY ./bin/Debug/netcoreapp2.1/publish .
RUN chmod 777 .
EXPOSE 60406
CMD ["dotnet", "everisapi.API.dll"]