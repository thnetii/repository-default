# EditorConfig configuration

Download command:

``` sh
curl -o .editorconfig -LRJ "https://github.com/thnetii/repository-default/raw/main/EditorConfig/.editorconfig"
```

From [the EditorConfig website](https://editorconfig.org/)

> EditorConfig helps developers define and maintain consistent coding styles between different editors and IDEs. The EditorConfig project consists of **a file format** for defining coding styles and a collection of **text editor plugins** that enable editors to read the file format and adhere to defined styles. EditorConfig files are easily readable and they work nicely with version control systems.

I regurlarly update and add definitions to this file whenever I encounter a new text file type.

Generally I like to use whatever line-endings and character encodings the system uses, instead of enforcing them in EditorConfig.

Otherwise, I am a great fan of using the community accepted default for tab vs. spaces in the various programming languages I dabble with. I like to include **ONE** `.editorconfig` at the root of a repository, therefore each `.editorconfig` sets `root = true` by default.
