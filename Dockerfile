# Use the official Microsoft .NET image for runtime.
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the official Microsoft .NET SDK image for building the app.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project files and restore dependencies.
COPY ["TestDeployBlazor.csproj", "./"]
RUN dotnet restore "TestDeployBlazor.csproj"

# Copy the rest of your app's source code and build the application.
COPY . .
RUN dotnet build "TestDeployBlazor.csproj" -c Release -o /app/build

# Publish the app using .NET CLI.
FROM build AS publish
RUN dotnet publish "TestDeployBlazor.csproj" -c Release -o /app/publish

# Final stage/image.
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestDeployBlazor.dll"]
