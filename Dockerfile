FROM rdissertori/jenkins-slave as slave
FROM mcr.microsoft.com/dotnet/core/sdk:2.2-alpine3.9
FROM microsoft/azure-cli:latest
FROM mcr.microsoft.com/powershell:6.2.2-alpine-3.8
