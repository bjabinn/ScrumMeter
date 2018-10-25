# FROM microsoft/dotnet:sdk AS build-env
# WORKDIR /app
# ENV http_proxy http://10.116.8.100:8080
# ENV https_proxy http://10.116.8.100:8080
# # Copy csproj and restore as distinct layers
# COPY *.csproj ./
# RUN dotnet restore

# # Copy everything else and build
# COPY . ./
# RUN dotnet publish -c Release -o out

# # Build runtime image
# FROM microsoft/dotnet:aspnetcore-runtime
# WORKDIR /app
# COPY --from=build-env /app/out .
# ENTRYPOINT ["dotnet", "everisapi.API.dll"]

FROM microsoft/aspnetcore-build
 
WORKDIR /home/app
 
COPY . /home/app
 
RUN dotnet restore
 
RUN dotnet publish ./AccountOwnerServer/everisapi.API.csproj -o /publish/
 
WORKDIR /publish
 
ENTRYPOINT ["dotnet", "everisapi.API.dll"]