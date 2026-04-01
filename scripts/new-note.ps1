param(
    [Parameter(Mandatory = $true)]
    [string]$Title,

    [string]$Tags = "inbox",

    [ValidateSet("inbox", "daily", "projects", "topics")]
    [string]$Section = "inbox"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$targetDir = Join-Path $repoRoot "notes/$Section"

if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

$date = Get-Date -Format "yyyy-MM-dd"

# Build an ASCII-safe filename slug.
$slug = $Title.ToLower()
$slug = [Regex]::Replace($slug, "[^a-z0-9]+", "-")
$slug = $slug.Trim("-")
if ([string]::IsNullOrWhiteSpace($slug)) {
    $slug = "note"
}

$fileName = "$date-$slug.md"
$filePath = Join-Path $targetDir $fileName

if (Test-Path $filePath) {
    throw "File already exists: $filePath"
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

$content = @"
---
title: "$Title"
tags: [$tagsValue]
created: $date
updated: $date
status: draft
---

# Контекст

Коротко: о чем заметка и зачем.

# Основное

- 

# Следующие шаги

- [ ] 

# Ссылки

- 
"@

Set-Content -Path $filePath -Value $content -Encoding UTF8
Write-Output "Created: $filePath"
