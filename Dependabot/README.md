# Dependabot

The dependabot configuration file is placed in the `.dependabot/config.yml` file in your repository. I have a default configuration file for various languages.

## Default

First run the following command to create and prime the `config.yml` file:

**Windows**
``` bat
MD .dependabot & curl -LRJ -o .dependabot\config.yml "https://github.com/thnetii/repository-default/raw/master/Dependabot/default.config.yml"
```
**Linux**
``` sh
mkdir -p .dependabot \
& curl -LRJ -o .dependabot\config.yml "https://github.com/thnetii/repository-default/raw/master/Dependabot/default.config.yml"
```

## Language specific configuration

|Language|Command|
|-|-|
|Git<br/>Submodules| `curl -L "https://github.com/thnetii/repository-default/raw/master/Dependabot/git-submodules.config.yml" >> .dependabot\config.yml`|
|.NET<br/>Nuget| `curl -L "https://github.com/thnetii/repository-default/raw/master/Dependabot/dotnet-nuget.config.yml" >> .dependabot\config.yml`|
|NPM<br/>JavaScript| `curl -L "https://github.com/thnetii/repository-default/raw/master/Dependabot/javascript.config.yml" >> .dependabot\config.yml`|

*Note: For the Git submodules usage, it might be a good idea to also create an empty `.gitmodules` to prevent Dependabot from complaining.*

***Windows:***
``` bat
ECHO.> .gitmodules
```
***Linux:***
``` sh
touch .gitmodules
```
