# Automated Initialization scripts

## .NET Core

After cloning a new repository run the following command: (requires PowerShell)

``` sh
pwsh -NoProfile -ExecutionPolicy unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://github.com/thnetii/repository-default/raw/master/Initialize/DotNet-Repository.ps1')))"
```