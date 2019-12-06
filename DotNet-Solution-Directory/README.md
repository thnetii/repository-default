# .NET Solution Directory support files

I do a lot of .NET development. I also like my repository automatically set up for a multi-project directory structure.

In your repository root, you can run the following command to fetch (or update) the solution support files.

``` sh
curl -LORJ "https://github.com/thnetii/repository-default/raw/master/DotNet-Solution-Directory/AllRules.ruleset" -LORJ "https://github.com/thnetii/repository-default/raw/master/DotNet-Solution-Directory/Directory.Build.props" -LORJ "https://github.com/thnetii/repository-default/raw/master/DotNet-Solution-Directory/Directory.Meta.props"
```

My default solution directory structure:

``` txt
root
├─ .azure-pipelines
├─ bin (compiler binary output directory)
|  ├─ Debug
|  |  ├─ netstandard1.3
|  |  └─ netstandard2.0
|  └─ Release
|     ├─ netstandard1.3
|     └─ netstandard2.0
├─ obj (Compiler intermediate directory)
|  └─ ...
├─ src
|  └─ ...
├─ sample
|  └─ ...
├─ test
|  └─ ...*.Test
├─ .gitignore
├─ .gitattributes
├─ .editorconfig (synced from here)
├─ LICENSE
├─ README.md
├─ AllRules.ruleset (synced from here)
├─ Directory.Build.props (synced from here)
├─ Directory.Nullable.props (individual extension for Directory.Build.props)
├─ Directory.Build.targets (synced from here)
├─ Directory.Meta.props (individual extension for Directory.Build.props)
├─ Directory.Version.props (individual extension for Directory.Build.props)
└─ *.sln
```

## `AllRules.ruleset` file

This is a ruleset file for Visual Studio Code Analysis enabling all Code Analysis rules. This file is referenced by the `Directory.Build.props` file.

## `Directory.Build.props` file

This is a general-purpose `Directory.Build.props` MSBuild properties file that will automatically be found and applied by all MSBuild projects underneath its directory tree.

### Setting MSBuild BasePath properties

In order to get all intermediate and binary output files at the solution root in the `bin` and `obj` folders, the `Directory.Build.props` file overrides the MSBuild `BaseOutputPath` and `BaseIntermediateOutputPath` properties.

Since very seldom needed I have not included the corresponding settings for Visual C/C++ settings which are `IntDir` and `OutDir` with the same corresponding values.

### .NET Assembly and NuGet package Metadata

`Directory.Build.props` also sets package metadata to sensible default values. You need to modify the lines setting `RepositoryUrl`, `PackageLicenseUrl` and `PackageProjectUrl`. I also do that by replacing
the following string with the correct one:

``` txt
githubuser/githubrepo
```

Forks of this repository should probably also change the `Authors`, `Company` and `Copyright` values at the top.

### Versioning scheme

I like to use a solution-wide common versioning scheme by default, setting version properties individually in each project can override the setting in `Directory.Build.props`.

It is enough to set the `VersionPrefix` property. This file assumes a 3-component version number. That version number is used also as the assembly file version and as the assembly version number.

If the `BuildNumber` property is set, e.g. by a CI system, it is appended as the 4th version component.

Finally for NuGet package version, the assembly informational version is used, which will use the 3-component version and append a suffix to create a proper semver-version. The default suffix is `-b$(BuildNumber)`.

### Default package includes

Finally, `Directory.Build.props` declares NuGet package references that all projects in the solution should reference. I always include all the FxCop Code Analyzers as well as the .NET Compatability analyser.

Note that the version numbers here cannot be set by tools like `dotnet outdated -u` and have to be kept up to date manually. `dotnet outdated` does correctly detect the packages included here though, so updating the remaining project-level depencies works as expected.

### Specify Default Target Framework Moniker

For CI build `Directory.Build.props` sets the `TargetFramework` property if `BuildDefaultTargetFramework` is non-empty.

This is only useful for multi-targeting projects as single target projects will set `TargetFramework` and thus override the setting anyways. However, for CI build this `BuildDefaultTargetFramework` can be specified if you want CI build to do a pack and publish after building and testing. Note that `Release` pipelines probably should set the `TargetFramework` directly for each project in order to actually make releases for **all** targets.

### Enable SourceLink

`Directory.Build.props` also includes the necessary settings for SourceLink.

## C# 8 Nullable support for pre .NET Standard 2.1

Add the `Directory.Nullable.props` file next to the `Directory.Build.props` file in your repository. It will enable usage of Nullable reference types and also make it possible to use extended nullability annotation attributes in projects targeting TFMs before .NET Standard 2.1 (or .NET Core App 3.0).

``` sh
curl -LORJ "https://github.com/thnetii/repository-default/raw/master/DotNet-Solution-Directory/Directory.Nullable.props"
```
