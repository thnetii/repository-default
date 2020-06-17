# Fix Line Endings

When downloading files from this repository using the raw links provided in the various README files, GitHub will provide you with the exact representation of the file in the Git index.

This can lead to mismatching line endings, especially when on Windows (since the files stored in the Git index strive to use Unix-style line endings).

Execute the following powershell script to recusively read the text content of all files in the current folder and write them back using the current environment's line endings and appliying UTF-8 text encoding without BOM.

## Windows PowerShell

``` bat
powershell -NoProfile -ExecutionPolicy unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://github.com/thnetii/repository-default/raw/master/Fix-Line-Endings/Rewrite-All-Files.ps1')))"
```

## PowerShell Core

``` sh
pwsh -NoProfile -ExecutionPolicy unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://github.com/thnetii/repository-default/raw/master/Fix-Line-Endings/Rewrite-All-Files.ps1')))"
```
