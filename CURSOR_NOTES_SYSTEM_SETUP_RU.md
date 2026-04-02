# Полная инструкция: развернуть систему заметок в Cursor с нуля

Документ для свежей Windows-машины с установленным Cursor Pro и новой учетной записью GitHub.

---

## 1) Что получится в итоге

После выполнения шагов у вас будет:

- Репозиторий `notes-git` с заметками в Markdown.
- Шаблон заметки с тегами.
- Команды:
  - `nn` — быстро создать заметку,
  - `nlast` — открыть последнюю заметку,
  - `nsync` — синхронизировать с GitHub.
- Синхронизация этой же базы заметок с Ubuntu VDS 24.04 через SSH.

---

## 2) Предусловия

Нужно установить:

- Cursor (Windows).
- Git for Windows.
- PowerShell (встроен в Windows 10/11).

Проверьте версии:

```powershell
git --version
powershell -v
```

---

## 3) Новая регистрация GitHub

1. Откройте [github.com/signup](https://github.com/signup).
2. Создайте новый аккаунт (email, пароль, username).
3. Подтвердите email.
4. Включите 2FA:
   - `Settings -> Password and authentication -> Two-factor authentication`.
5. (Опционально) заполните профиль и аватар.

---

## 4) Первичная настройка Git на Windows

Запустите PowerShell:

```powershell
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL"
git config --global init.defaultBranch master
```

Проверка:

```powershell
git config --global --list
```

---

## 5) Создать SSH-ключ и подключить GitHub

### 5.1 Создание ключа

```powershell
ssh-keygen -t ed25519 -C "github-windows-notes"
```

Нажимайте Enter для пути по умолчанию. Пароль для ключа — по желанию.

### 5.2 Добавить ключ в ssh-agent

```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

### 5.3 Добавить публичный ключ в GitHub

Показать ключ:

```powershell
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
```

Скопируйте вывод и добавьте в GitHub:

- `Settings -> SSH and GPG keys -> New SSH key`
- Title: `Windows Cursor`
- Key type: `Authentication Key`

### 5.4 Проверка SSH

```powershell
ssh -T git@github.com
```

Ожидаемо: приветствие вида `Hi <username>! You've successfully authenticated...`

---

## 6) Создать репозиторий заметок на GitHub

1. В GitHub: `New repository`
2. Name: `notes-git`
3. Private/Public — на выбор.
4. **Не** добавлять README/.gitignore (пустой репозиторий).
5. Нажать `Create repository`.

---

## 7) Локальная структура проекта заметок

Откройте PowerShell и выполните:

```powershell
cd $env:USERPROFILE\Documents
mkdir notes-git
cd notes-git
git init
mkdir notes,inbox,daily,projects,topics,scripts,templates
```

Если команда `mkdir` создала не ту структуру (из-за синтаксиса), создайте отдельно:

```powershell
mkdir notes
mkdir notes\inbox
mkdir notes\daily
mkdir notes\projects
mkdir notes\topics
mkdir scripts
mkdir templates
```

Создайте `.gitignore`:

```text
Thumbs.db
.DS_Store
```

---

## 8) Создать шаблон заметки (UTF-8, с тегами)

Файл: `templates/note-template.md`

```md
---
title: "__TITLE__"
tags: [__TAGS__]
created: __DATE__
updated: __DATE__
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
```

Важно: сохранить файл в UTF-8.

---

## 9) Создать скрипт генерации заметки

Файл: `scripts/new-note.ps1`

```powershell
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

# Transliterate Cyrillic title to Latin for file slug.
$slugSourceBuilder = New-Object System.Text.StringBuilder
foreach ($ch in $Title.ToLower().ToCharArray()) {
    $code = [int][char]$ch
    $latin = switch ($code) {
        1072 { "a" }; 1073 { "b" }; 1074 { "v" }; 1075 { "g" }; 1076 { "d" }; 1077 { "e" }
        1105 { "e" }; 1078 { "zh" }; 1079 { "z" }; 1080 { "i" }; 1081 { "y" }; 1082 { "k" }
        1083 { "l" }; 1084 { "m" }; 1085 { "n" }; 1086 { "o" }; 1087 { "p" }; 1088 { "r" }
        1089 { "s" }; 1090 { "t" }; 1091 { "u" }; 1092 { "f" }; 1093 { "kh" }; 1094 { "ts" }
        1095 { "ch" }; 1096 { "sh" }; 1097 { "shch" }; 1098 { "" }; 1099 { "y" }; 1100 { "" }
        1101 { "e" }; 1102 { "yu" }; 1103 { "ya" }
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
if ($tagList.Count -eq 0) { $tagList = @("inbox") }
$tagsValue = ($tagList -join ", ")

$templatePath = Join-Path $repoRoot "templates/note-template.md"
if (!(Test-Path $templatePath)) { throw "Template not found: $templatePath" }

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
```

Создайте удобный запуск:

Файл: `new-note.cmd`

```cmd
@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\new-note.ps1" %*
```

---

## 10) Настроить alias в PowerShell

Откройте профиль:

```powershell
notepad $PROFILE
```

Добавьте:

```powershell
function nn {
  param(
    [Parameter(Mandatory=$true)][string]$t,
    [string]$tags = "inbox",
    [string]$s = "inbox"
  )
  & "C:\Users\YOUR_USER\Documents\notes-git\new-note.cmd" -Title $t -Tags $tags -Section $s
}

function nsync {
  param(
    [string]$repo = "C:\Users\YOUR_USER\Documents\notes-git",
    [string]$branch = "master"
  )
  Push-Location $repo
  try {
    git pull --rebase origin $branch
    git push origin $branch
    git status -sb
  }
  finally {
    Pop-Location
  }
}

function nlast {
  param(
    [string]$repo = "C:\Users\YOUR_USER\Documents\notes-git"
  )
  $latest = Get-ChildItem -Path (Join-Path $repo "notes") -Recurse -File -Filter "*.md" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
  if (-not $latest) { Write-Error "No Markdown notes found"; return }
  code $latest.FullName
}
```

Замените `YOUR_USER` на имя пользователя Windows.

Если профиль не грузится из-за policy:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
```

или временно на текущую сессию:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
. $PROFILE
```

---

## 11) Подключить локальный репозиторий к GitHub

В `notes-git`:

```powershell
git remote add origin git@github.com:YOUR_GITHUB_USERNAME/notes-git.git
git add .
git commit -m "chore(notes): initialize notes system"
git push -u origin master
```

---

## 12) Ежедневный workflow

Создать заметку:

```powershell
nn "План главы про AI в логистике" "daily,planning,ai" "daily"
```

Открыть последнюю заметку:

```powershell
nlast
```

Синхронизировать:

```powershell
nsync
```

Если `nsync` пишет, что есть незакоммиченные изменения:

```powershell
cd C:\Users\YOUR_USER\Documents\notes-git
git add .
git commit -m "docs(notes): update notes"
nsync
```

---

## 13) Синхронизация с Ubuntu VDS 24.04

### 13.1 На VDS: базовая установка

```bash
sudo apt update && sudo apt install -y git openssh-client
git --version
```

### 13.2 На VDS: SSH-ключ

```bash
ssh-keygen -t ed25519 -C "github-vds-notes"
cat ~/.ssh/id_ed25519.pub
```

Добавьте этот ключ в GitHub (`Settings -> SSH and GPG keys`) как второй ключ.

Проверка:

```bash
ssh -T git@github.com
```

### 13.3 Клонирование

```bash
git clone git@github.com:YOUR_GITHUB_USERNAME/notes-git.git
cd notes-git
```

### 13.4 Цикл работы с двух машин

- На Windows перед push:
  - `git add .`
  - `git commit -m "..."`
  - `git push`
- На VDS перед работой:
  - `git pull --rebase`
- На VDS после правок:
  - `git add . && git commit -m "..." && git push`

Правило: перед каждым `push` делайте `pull --rebase`.

---

## 14) Рекомендации по структуре тегов

Минимальный словарь:

- Тип: `idea`, `task`, `meeting`, `research`, `daily`.
- Домен: `ai`, `logistics`, `tex`, `backend`, `agent`.
- Статус: `draft`, `review`, `done`.
- Приоритет: `p1`, `p2`, `p3`.

Пример:

```yaml
tags: [research, agent, ai, p1]
```

---

## 15) Рекомендации для Cursor Pro

- Включить autosave в Cursor settings.
- Установить Markdown lint/preview расширения (по желанию).
- Создать workspace на `notes-git`.
- Использовать быстрые промпты:
  - "структурируй заметку как план + чеклист",
  - "сделай краткое резюме и action items",
  - "преобразуй заметку в план статьи/доклада".

---

## 16) Чеклист готовности (Done)

- [ ] GitHub аккаунт создан и подтвержден.
- [ ] SSH-ключи Windows и VDS добавлены в GitHub.
- [ ] Репозиторий `notes-git` создан и запушен.
- [ ] `nn`, `nlast`, `nsync` работают.
- [ ] Новая заметка создается с русским текстом без проблем кодировки.
- [ ] Синхронизация Windows <-> GitHub <-> VDS работает.

---

## 17) Быстрая диагностика проблем

### `nn` не найден

```powershell
. $PROFILE
Get-Command nn
```

### Ошибка подписи скриптов

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
```

### `pull --rebase` не идет (есть локальные изменения)

```powershell
git add .
git commit -m "wip: save local changes"
git pull --rebase
```

### `Permission denied (publickey)` на GitHub

- Проверьте, что ключ добавлен в GitHub.
- Проверьте `ssh -T git@github.com`.
- Проверьте, что remote использует SSH (`git@github.com:...`), не HTTPS.

---

Готово. Эта инструкция покрывает полный цикл: с новой регистрации GitHub до рабочей multi-device системы заметок в Cursor.
