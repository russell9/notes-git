# Notes Git

Личный репозиторий заметок в Markdown с тегами.

## Структура

- `notes/inbox/` - быстрые черновики
- `notes/daily/` - ежедневные заметки
- `notes/projects/` - заметки по проектам
- `notes/topics/` - заметки по темам
- `templates/` - шаблоны

## Как писать заметку

1. Скопируй `templates/note-template.md`
2. Сохрани в нужную папку как `YYYY-MM-DD-name.md`
3. Укажи теги в `tags: [...]`

## Пример тегов

- `idea`
- `task`
- `research`
- `backend`
- `urgent`

## Поиск в Cursor

- По frontmatter: `tags: [backend`
- По хеш-тегам в тексте: `#backend`

## Быстрое создание заметки

Из корня репозитория:

```powershell
.\scripts\new-note.ps1 -Title "Идея API слоя" -Tags "idea,backend,urgent" -Section projects
```

Или через короткий запуск:

```powershell
.\new-note.cmd -Title "Дневная заметка" -Tags "daily,planning" -Section daily
```

Параметры:

- `-Title` (обязательный)
- `-Tags` (по умолчанию `inbox`, через запятую)
- `-Section` (`inbox`, `daily`, `projects`, `topics`)

## Терминал: тот же сценарий, что `/note-parent-research` (npr)

Команда в Cursor — это файл `.cursor/commands/note-parent-research.md`. В терминале короткий вызов: **`npr`** (после добавления функции в профиль PowerShell) или `.\scripts\npr.ps1`.

Обязательно укажи **путь к заметке** (в чате IDE «текущий файл» известен самому Cursor; из терминала — только явный путь):

```powershell
npr "C:\Users\YOUR\Documents\notes-git\notes\inbox\2026-04-02-example.md"
```

- Если в PATH есть **Cursor Agent CLI** (`agent` с [cursor.com/install](https://cursor.com/install)), скрипт выполнит `agent chat` с полным текстом спецификации и этим путём, рабочая папка — `notes-git`.
- Если `agent` нет — в буфер копируется **тот же полный промпт**; вставь его в чат Agent в Cursor (Cmd/Ctrl+L) — результат тот же, что вставка инструкции вручную.

Проверка без запуска агента: `npr -WhatIf "...\note.md"`

## Git workflow

```bash
git add .
git commit -m "docs(notes): add new notes"
git push
```
