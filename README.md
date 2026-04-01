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

## Git workflow

```bash
git add .
git commit -m "docs(notes): add new notes"
git push
```
