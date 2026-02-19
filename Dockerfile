# ==============================
# Stage 1: Build
# ==============================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy solution file (.slnx!)
COPY UserManagement.slnx ./

# Copy project files
COPY UserManagement.API/*.csproj ./UserManagement.API/
COPY UserManagement.Application/*.csproj ./UserManagement.Application/
COPY UserManagement.Domain/*.csproj ./UserManagement.Domain/
COPY UserManagement.Infrastructure/*.csproj ./UserManagement.Infrastructure/

# Restore
RUN dotnet restore UserManagement.slnx

# Copy everything else
COPY . .

# Publish API project
RUN dotnet publish UserManagement.API/UserManagement.API.csproj -c Release -o /app/publish

# ==============================
# Stage 2: Runtime
# ==============================
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 80
ENTRYPOINT ["dotnet", "UserManagement.API.dll"]
