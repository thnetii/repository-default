[CmdletBinding()]
param ()

Get-Command git | Out-Null

$PSCmdlet.WriteVerbose("Adding gitattributes and gitignore to repository")
Invoke-WebRequest "https://github.com/thnetii/repository-default/raw/master/GitFiles/.gitattributes" `
    -OutFile ".gitattributes"
Invoke-WebRequest "https://github.com/github/gitignore/raw/master/VisualStudio.gitignore" `
    -OutFile ".gitignore"

$PSCmdlet.WriteVerbose("Adding EditorConfig to repository")
Invoke-WebRequest "https://github.com/thnetii/repository-default/raw/master/EditorConfig/.editorconfig" `
    -OutFile ".editorconfig"

$PSCmdlet.WriteVerbose("Adding .NET Solution Root files to repository")
function Get-GitRepositoryUrl {
    [OutputType([string])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$GitRepositoryUrl
    )

    return $GitRepositoryUrl
}

$GitFolder = Join-Path (Get-Location) ".git"
[string]$GitRepositoryUrl = $null
if (Test-Path -PathType Container $GitFolder) {
    [string]$GitRepositoryUrl = & git config --get remote.origin.url | Select-Object -First 1
} 
while (-not $GitRepositoryUrl) {
    [string]$GitRepositoryUrl = Get-GitRepositoryUrl
}
if ($GitRepositoryUrl.EndsWith(".git", [System.StringComparison]::OrdinalIgnoreCase)) {
    $GitRepositoryUrl = $GitRepositoryUrl.Substring(0, $GitRepositoryUrl.Length - 4)
}

[xml]$DotnetMetaProps = Get-Content -ErrorAction "SilentlyContinue" `
    -Path "Directory.Meta.props"
if ($DotnetMetaProps) {
    [System.Xml.XmlElement]$DotnetCommonPackageMetadata = `
          $DotnetMetaProps.DocumentElement.PropertyGroup `
        | Where-Object -Property Label -like "Common Package Metadata"
}

[uri[]]$DotnetFileUris = @(
    "https://github.com/thnetii/repository-default/raw/master/DotNet-Solution-Directory/AllRules.ruleset",
    "https://github.com/thnetii/repository-default/raw/master/DotNet-Solution-Directory/Directory.Build.props",
    "https://github.com/thnetii/repository-default/raw/master/DotNet-Solution-Directory/Directory.Meta.props",
    "https://github.com/thnetii/repository-default/raw/master/DotNet-Solution-Directory/Directory.Version.props",
    "https://github.com/thnetii/repository-default/raw/master/DotNet-Solution-Directory/Directory.Build.targets"
)
$DotnetFileUris | ForEach-Object {
    $DotnetFileName = $_.Segments | Select-Object -Last 1
    Invoke-WebRequest -Uri $_ -OutFile $DotnetFileName
}
[xml]$DotnetMetaSourceProps = Get-Content "Directory.Meta.props"
[System.Xml.XmlElement]$DotnetMetaSourceCommonPackageMetadata = `
      $DotnetMetaSourceProps.DocumentElement.PropertyGroup `
    | Where-Object -Property Label -like "Common Package Metadata"
if ($DotnetCommonPackageMetadata) {
    $DotnetCommonPackageMetadata.ChildNodes | Where-Object { $_.GetType() -eq [System.Xml.XmlElement] } | ForEach-Object {
        [System.Xml.XmlElement]$PropertyOriginal = $_
        [System.Xml.XmlElement]$PropertyTarget = $DotnetMetaSourceCommonPackageMetadata[$PropertyOriginal.LocalName]
        $PropertyTarget.InnerText = $PropertyOriginal.InnerText
    }
}
[System.Xml.XmlElement]$DotnetMetaPackageProjectUrlElement = $DotnetMetaSourceCommonPackageMetadata["PackageProjectUrl"]
$DotnetMetaPackageProjectUrlElement.InnerText = $GitRepositoryUrl
$DotnetMetaSourceProps.Save((Resolve-Path "Directory.Meta.props"))

$PSCmdlet.WriteVerbose("Adding Dependabot configuration to repository")
New-Item -ItemType Directory ".dependabot" -Force | Out-Null
$dependabotConfigFile = Join-Path ".dependabot" "config.yml"
(Invoke-WebRequest "https://github.com/thnetii/repository-default/raw/master/Dependabot/default.config.yml" -UseBasicParsing).Content |`
    Out-File $dependabotConfigFile -NoNewLine
(Invoke-WebRequest "https://github.com/thnetii/repository-default/raw/master/Dependabot/git-submodules.config.yml" -UseBasicParsing).Content |`
    Out-File $dependabotConfigFile -Append -NoNewLine
(Invoke-WebRequest "https://github.com/thnetii/repository-default/raw/master/Dependabot/dotnet-nuget.config.yml" -UseBasicParsing).Content |`
    Out-File $dependabotConfigFile -Append -NoNewLine
if (-not (Test-Path ".gitmodules")) {
    New-Item -ItemType File ".gitmodules" | Out-Null
}

$PSCmdlet.WriteVerbose("Applying line-endings and text encoding to all repository files")
& ([scriptblock]::Create((Invoke-WebRequest "https://github.com/thnetii/repository-default/raw/master/Fix-Line-Endings/Rewrite-All-Files.ps1" -UseBasicParsing)))
