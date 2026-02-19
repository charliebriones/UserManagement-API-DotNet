FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build  # use correct SDK version
WORKDIR /src

# Copy solution file first
COPY *.sln ./

# Copy all projects
COPY UserManagement.API/*.csproj ./UserManagement.API/
COPY UserManagement.Application/*.csproj ./UserManagement.Application/
COPY UserManagement.Infrastructure/*.csproj ./UserManagement.Infrastructure/

# Restore all dependencies
RUN dotnet restore

# Copy everything else
COPY . .

# Build
RUN dotnet build -c Release --no-restore

# Publish
RUN dotnet publish -c Release -o /app --no-build

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app .
EXPOSE 80
ENTRYPOINT ["dotnet", "UserManagement.API.dll"]
