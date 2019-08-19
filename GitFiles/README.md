# Git files

Contains git repository root dotfiles.

There are two of them

* [`.gitignore`](#gitignore-file)
* [`.gitatrributes`](#gitattributes-file)

## `.gitattributes` file

Download command:

``` sh
curl -o .gitattributes -LRJ "https://github.com/thnetii/repository-default/raw/master/GitFiles/.gitattributes"
```

The `.gitattributes` file is a dotfile that instructs Git on how to handle file checkouts, commits and changes for files in your repository.

The file was originally created by Visual Studio 2017, and I have subsequently added by own attributes at the end.

Node.js, NPM and Yarn all *really* want to use UNIX-like line endings (LF) even when on Windows. This causes false positives on changes to these files.

Therefore I enforce LF line-endings by Git for the affected files. On Linux, these settings have no effect.

## `.gitignore` file

This downloads the most recent version of the Visual Studio `.gitignore` on the master-branch of https://github.com/github/gitignore

Download command:

``` sh
curl -o .gitignore -LRJ "https://github.com/github/gitignore/raw/master/VisualStudio.gitignore"
```
