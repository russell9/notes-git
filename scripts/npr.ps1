<#
.SYNOPSIS
  Terminal entry for the same workflow as Cursor slash command /note-parent-research.

.DESCRIPTION
  1) If Cursor Agent CLI (agent) is on PATH, runs: agent chat "<full prompt>" with cwd = notes-git.
     The prompt is the full text of .cursor/commands/note-parent-research.md plus the target note path.
  2) If agent is missing, copies that full prompt to the clipboard - paste into Cursor Agent chat.

  Install CLI: https://cursor.com/install

.EXAMPLE
  npr.ps1 -File .\notes\inbox\2026-04-02-my-note.md
#>
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

$notesGit = Join-Path $env:USERPROFILE "Documents\notes-git"
$specPath = Join-Path $notesGit ".cursor\commands\note-parent-research.md"

if (-not (Test-Path -LiteralPath $specPath)) {
    Write-Error "Command spec not found: $specPath"
    exit 1
}

$resolved = if ([System.IO.Path]::IsPathRooted($File)) { $File } else { Join-Path (Get-Location).Path $File }
if (-not (Test-Path -LiteralPath $resolved)) {
    Write-Error "Note file not found: $resolved"
    exit 1
}
$absNote = (Resolve-Path -LiteralPath $resolved).Path

$commandSpec = [System.IO.File]::ReadAllText($specPath, [System.Text.UTF8Encoding]::new($false))

$fullPrompt = @"
Execute the following Cursor custom-command specification for ONE markdown note only.
Use the absolute path below as the target file. Respect all guards (root note, hub_research_applied).
Work in the notes-git workspace when resolving projects.bib and paths.

--- BEGIN SPEC (note-parent-research) ---
$commandSpec
--- END SPEC ---

**Target note file (only this file):** $absNote
"@

if ($WhatIf) {
    Write-Host "Prompt length: $($fullPrompt.Length) chars"
    Write-Host "Target: $absNote"
    exit 0
}

function Find-Agent {
    $g = Get-Command agent -CommandType Application -ErrorAction SilentlyContinue
    if ($g) { return $g.Source }
    foreach ($p in @(
            (Join-Path $env:USERPROFILE "cursor\bin\agent.exe"),
            (Join-Path $env:USERPROFILE "cursor\bin\agent.cmd"),
            (Join-Path $env:USERPROFILE ".local\bin\agent.exe")
        )) {
        if ($p -and (Test-Path -LiteralPath $p)) { return $p }
    }
    return $null
}

$agentExe = Find-Agent

if (-not $agentExe) {
    Set-Clipboard -Value $fullPrompt
    Write-Warning 'Cursor Agent CLI (agent) not found on PATH.'
    Write-Host 'Install: https://cursor.com/install'
    Write-Host 'Full prompt (spec + target path) copied to clipboard - paste into Cursor Agent chat (Cmd/Ctrl+L).'
    exit 0
}

Push-Location $notesGit
try {
    & $agentExe chat $fullPrompt
    if ($null -ne $LASTEXITCODE -and $LASTEXITCODE -ne 0) {
        Write-Warning "agent chat exited with code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}
