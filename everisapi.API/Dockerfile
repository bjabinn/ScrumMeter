FROM microsoft/dotnet:sdk AS build-env
ENV HTTP_PROXY "http://10.0.8.102:8080"
ENV HTTPS_PROXY "http://10.0.8.102:8080"
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
#RUN dotnet publish -c Release -o out
RUN dotnet publish -o out

# Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
ENV HTTP_PROXY "http://10.0.8.102:8080"
ENV HTTPS_PROXY "http://10.0.8.102:8080"
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "everisapi.API.dll"]



# FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
# ENV HTTP_PROXY "http://10.0.8.102:8080"
# ENV HTTPS_PROXY "http://10.0.8.102:8080"
# WORKDIR /app

# FROM microsoft/dotnet:2.2-sdk AS build
# ENV HTTP_PROXY "http://10.0.8.102:8080"
# ENV HTTPS_PROXY "http://10.0.8.102:8080"
# #WORKDIR /app
# COPY . ./
# RUN dotnet restore everisapi.API.csproj
# RUN dotnet build everisapi.API.csproj -c Release -o /app
 
# FROM build AS publish
# ENV HTTP_PROXY "http://10.0.8.102:8080"
# ENV HTTPS_PROXY "http://10.0.8.102:8080"
# #WORKDIR /app
# RUN dotnet publish everisapi.API.csproj -c Release -o /app
 
# FROM base AS final
# ENV HTTP_PROXY "http://10.0.8.102:8080"
# ENV HTTPS_PROXY "http://10.0.8.102:8080"
# #WORKDIR /app
# COPY --from=publish /app .
# ENTRYPOINT ["dotnet", "everisapi.API.dll"]