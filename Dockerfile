# Use the .NET 10 SDK for building
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

# Set working directory
WORKDIR /src

# Copy solution file
COPY *.sln ./

# Copy all project files
COPY UserManagement.API/*.csproj ./UserManagement.API/
COPY UserManagement.Application/*.csproj ./UserManagement.Application/
COPY UserManagement.Infrastructure/*.csproj ./UserManagement.Infrastructure/

# Restore all projects
RUN dotnet restore

# Copy all source code
COPY . .

# Build the solution in Release mode
RUN dotnet build -c Release --no-restore

# Publish the API project
RUN dotnet publish UserManagement.API/UserManagement.API.csproj -c Release -o /app --no-build

# Use lightweight runtime image
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Copy the published output from build stage
COPY --from=build /app .

# Expose HTTP port
EXPOSE 80

# Entry point for the container
ENTRYPOINT ["dotnet", "UserManagement.API.dll"]
