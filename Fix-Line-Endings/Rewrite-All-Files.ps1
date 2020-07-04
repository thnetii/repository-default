[CmdletBinding()]
param ()

$PSCmdlet.WriteVerbose("Invoking command `"git ls-files`" on repository `"$(Get-Location)`".")
[string[]]$GitFiles = & git ls-files -mc

Get-ChildItem -File -Path $GitFiles | ForEach-Object {
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
