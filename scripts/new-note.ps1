param(
    [Parameter(Mandatory = $true)]
    [string]$Title,

    [string]$Tags = "inbox",
    [string]$Section = "inbox"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

$allowedSections = @("inbox", "daily", "projects", "topics")
$normalizedSection = (($Section -split ",")[0]).Trim().ToLower()
if ([string]::IsNullOrWhiteSpace($normalizedSection)) {
    $normalizedSection = "inbox"
}
if ($allowedSections -notcontains $normalizedSection) {
    throw "Invalid section '$Section'. Use one of: $($allowedSections -join ', ')"
}

$targetDir = Join-Path $repoRoot "notes/$normalizedSection"

if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

$date = Get-Date -Format "yyyy-MM-dd"

# Transliterate Cyrillic using Unicode code points (ASCII-only script source).
$slugSourceBuilder = New-Object System.Text.StringBuilder
foreach ($ch in $Title.ToLower().ToCharArray()) {
    $code = [int][char]$ch
    $latin = switch ($code) {
        1072 { "a" }     # а
        1073 { "b" }     # б
        1074 { "v" }     # в
        1075 { "g" }     # г
        1076 { "d" }     # д
        1077 { "e" }     # е
        1105 { "e" }     # ё
        1078 { "zh" }    # ж
        1079 { "z" }     # з
        1080 { "i" }     # и
        1081 { "y" }     # й
        1082 { "k" }     # к
        1083 { "l" }     # л
        1084 { "m" }     # м
        1085 { "n" }     # н
        1086 { "o" }     # о
        1087 { "p" }     # п
        1088 { "r" }     # р
        1089 { "s" }     # с
        1090 { "t" }     # т
        1091 { "u" }     # у
        1092 { "f" }     # ф
        1093 { "kh" }    # х
        1094 { "ts" }    # ц
        1095 { "ch" }    # ч
        1096 { "sh" }    # ш
        1097 { "shch" }  # щ
        1098 { "" }      # ъ
        1099 { "y" }     # ы
        1100 { "" }      # ь
        1101 { "e" }     # э
        1102 { "yu" }    # ю
        1103 { "ya" }    # я
        default { [string]$ch }
    }
    [void]$slugSourceBuilder.Append($latin)
}

$slug = $slugSourceBuilder.ToString()
$slug = [Regex]::Replace($slug, "[^a-z0-9]+", "-")
$slug = $slug.Trim("-")
if ([string]::IsNullOrWhiteSpace($slug)) {
    $slug = "note-" + (Get-Date -Format "HHmmss")
}

$fileName = "$date-$slug.md"
$filePath = Join-Path $targetDir $fileName

if (Test-Path $filePath) {
    $counter = 2
    do {
        $fileName = "$date-$slug-$counter.md"
        $filePath = Join-Path $targetDir $fileName
        $counter++
    } while (Test-Path $filePath)
}

$tagList = @()
foreach ($tag in ($Tags -split ",")) {
    $clean = $tag.Trim()
    if ($clean) { $tagList += $clean }
}
if ($tagList.Count -eq 0) {
    $tagList = @("inbox")
}

$tagsValue = ($tagList -join ", ")

$templatePath = Join-Path $repoRoot "templates/note-template.md"
if (!(Test-Path $templatePath)) {
    throw "Template not found: $templatePath"
}

$content = [System.IO.File]::ReadAllText(
    $templatePath,
    [System.Text.UTF8Encoding]::new($false)
)

$content = $content.Replace("__TITLE__", $Title)
$content = $content.Replace("__TAGS__", $tagsValue)
$content = $content.Replace("__DATE__", $date)

[System.IO.File]::WriteAllText(
    $filePath,
    $content,
    [System.Text.UTF8Encoding]::new($false)
)
Write-Output "Created: $filePath"
