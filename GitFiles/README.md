# Git files

Contains git repository root dotfiles.

There are two of them

- [Git files](#git-files)
  - [`.gitattributes` file](#gitattributes-file)
  - [`.gitignore` file](#gitignore-file)

## `.gitattributes` file

Download command:

``` sh
curl -o .gitattributes -LRJ "https://github.com/Dotnet-Boxed/Templates/raw/main/Source/GitattributesTemplate/.gitattributes"
```

The `.gitattributes` file is a dotfile that instructs Git on how to handle file checkouts, commits and changes for files in your repository.

The file is provided from the gitattributes template in the Dotnet-Boxed template.

## `.gitignore` file

This downloads the most recent version of the Visual Studio `.gitignore` on the master-branch of https://github.com/github/gitignore

Download command:

``` sh
curl -o .gitignore -LRJ "https://github.com/github/gitignore/raw/master/VisualStudio.gitignore"
```
