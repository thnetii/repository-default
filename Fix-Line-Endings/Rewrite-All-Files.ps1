[CmdletBinding()]
param ()

$PSCmdlet.WriteVerbose("Invoking command `"git ls-files --eol -mc`" on repository `"$(Get-Location)`".")
[string[]]$GitFilePatterns = & git ls-files --eol -mc

[regex]$GitLsFilesEolRegex = "^(\S+)\s+(\S+)\s+(.*)\s*\t(.*\S)\s*$"
[string[]]$GitFiles = $GitFilePatterns | ForEach-Object {
    $GitFileMatch = $GitLsFilesEolRegex.Match($_)
    $GitFilePath = $GitFileMatch.Groups[4].Value.Trim()
    $GitWorkEol = $GitFileMatch.Groups[2].Value.Trim()
    if ($GitWorkEol -like "w/none" -or `
        $GitWorkEol -like "w/-text") {
        $PSCmdlet.WriteWarning("Skipping renormalization of `"$GitFilePath`", eolinfo-status `"$GitWorkEol`"")
        return [string]::Empty
    }
    $GitFileAttr = $GitFileMatch.Groups[3].Value.Trim()
    if ($GitFileAttr -notlike "attr/text=auto*") {
        $PSCmdlet.WriteWarning("Skipping renormalization of `"$GitFilePath`", eolattr `"$GitFileAttr`" is not `"attr/text=auto`"")
        return [string]::Empty
    }
    return $GitFilePath
} | Where-Object { -not ([string]::IsNullOrWhiteSpace($_)) }

Get-ChildItem -File -Path $GitFiles | Where-Object {
    $FilePath = $_.FullName
    return -not ($ExcludePatterns | Where-Object { $FilePath -like $_ } | Select-Object -First 1)
} | ForEach-Object {
    Write-Host $(Resolve-Path -Relative $_.FullName)
    [string[]]$content = $_ | Get-Content
    # PowerShell before PowerShell Core v6.0 does not support utf8NoBOM as Encoding
    if ($PSVersionTable.PSVersion -lt [version]"6.0") {
        $encoding = [System.Text.UTF8Encoding]::new($false) # create UTF8 Encoding with no BOM
        if ($content -and $content.Length -gt 0)
        {
            $PSCmdlet.WriteVerbose("Performing the operation `"WriteAllLines`" on target `"Path: $($_.FullName)`" using text encoding $($encoding.WebName).")
            [System.IO.File]::WriteAllLines($_.FullName, $content, $encoding)
        }
        else {
            [byte[]]$emptyArray = [System.Array]::CreateInstance([byte], 0)
            $PSCmdlet.WriteVerbose("Performing the operation `"Truncate File`" on target `"Path: $($_.FullName)`".")
            [System.IO.File]::WriteAllBytes($_.FullName, $emptyArray)
        }
    } else {
        $_ | Set-Content -Value $content -Encoding utf8NoBOM
    }
}
