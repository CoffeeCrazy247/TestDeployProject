FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["TestDeployBlazor.csproj", "./"]
RUN dotnet restore "TestDeployBlazor.csproj"
COPY . .
RUN dotnet build "TestDeployBlazor.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestDeployBlazor.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestDeployBlazor.dll"]
