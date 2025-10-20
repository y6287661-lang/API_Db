# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Base image for production
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["First_API.csproj", "."]
RUN dotnet restore "./First_API/First_API.csproj"
COPY . .
WORKDIR "/src/First_API"
RUN dotnet build "./First_API.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "./First_API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "First_API.dll"]