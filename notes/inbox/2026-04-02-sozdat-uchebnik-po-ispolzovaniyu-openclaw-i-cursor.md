---
title: "Создать учебник по использованию OpenClaw и Cursor"
tags: [projects]
created: 2026-04-02
updated: 2026-04-02
status: draft
hub_research_applied: true
hub_research_applied_at: 2026-04-02
---

# @context

**Title:** Создать учебник по использованию OpenClaw и Cursor.

Исходная постановка в этой заметке была минимальной: шаблон «Контекст / Основное / Следующие шаги / Ссылки» без заполненного содержания. Суть задачи — подготовить **учебный материал**, который связывает **OpenClaw** (фреймворк/экосистема автономных агентов, self-hosted, интеграции с каналами и инструментами) и **Cursor** (IDE с глубокой интеграцией LLM, агентными режимами и специализированными моделями для кода). Контекст ограничен **этим файлом**; родительские заметки не подтягиваются. **Повторный проход исследования:** добавлены MCP как стандарт интеграции инструментов и отдельная эмпирика по GitHub Copilot для сравнения с выводами по Cursor.

# Контекст

Коротко: учебник должен помочь читателю освоить связку **разработка и оркестрация агентов** (OpenClaw) и **ежедневная работа с кодом и промптами** (Cursor), с упором на проверяемые источники, ограничения инструментов и практики качества.

## @goal

Сформировать **обзорную базу для учебника**: (1) что такое OpenClaw и какие у него типичные компоненты в продакшен-описаниях; (2) как устроен и чем измеряется **агентный** слой в Cursor (модели, бенчмарки, официальные отчёты); (3) какие **исследования** фиксируют эффекты AI-ассистентов в разработке и что это значит для педагогики учебника (velocity vs качество, QA); (4) смежные работы про опыт программирования с ИИ и мультиагентные паттерны — для структуры глав и ссылок на литературу; **(5)** явно связать учебный материал с **MCP** и с **бенчмарками реальных задач** (SWE-bench и аналоги), чтобы читатель понимал границы измерений «умение агента».

# Основное

## 1. OpenClaw: что закрепить в учебнике

OpenClaw в открытых материалах 2025–2026 позиционируется как **self-hosted** стек для долгоживущих агентов: шлюз/демон, маршрутизация по каналам (мессенджеры и др.), сессии, интеграция **MCP** и навыков, файловая конфигурация (в обзорах фигурируют markdown-артефакты вроде профилей агента, памяти, инструментов). Для учебника важно:

- отделить **концепции** (оркестратор, инструменты, память, политики безопасности) от **конкретной версии** репозитория;
- дать модуль «развёртывание + минимальный сценарий» и «расширение через MCP/воркфлоу»;
- указать, что детали API и релизы меняются — ссылка на **официальный GitHub** и release notes предпочтительнее вторичных гайдов.

Практический источник правды по коду и релизам: репозиторий [openclaw/openclaw](https://github.com/openclaw/openclaw) (теги релизов, changelog).

## 2. Cursor: слой IDE и агентные модели

Для учебника по Cursor полезно разделить три уровня:

1. **Редактор и контекст** — проект, правила, документация в репо, ограничение контекстного окна, ревью человеком.
2. **Режимы работы** (планирование, агент, вопросы) — как педагогический сценарий: сначала архитектура/спека, затем итерации с тестами и линтерами.
3. **Модели** — официальный технический отчёт по **Composer 2** описывает обучение под **agentic software engineering**, бенчмарки (в т.ч. SWE-bench Multilingual, Terminal-Bench, CursorBench) и связь с реальным «harness» Cursor [arXiv:2603.24477](https://arxiv.org/abs/2603.24477).

Блог Cursor с отчётом: [Composer 2 Technical Report](https://cursor.com/blog/composer-2-technical-report) (дублирует/сопровождает arXiv-версию).

## 3. Эмпирика: «ускорение» и долговременные риски качества

Эмпирическая работа He et al. (оформлена на arXiv и привязана к MSR 2026) оценивает **причинный эффект** внедрения Cursor в open-source проектах: рост краткосрочной скорости разработки и **устойчивое** увеличение предупреждений статического анализа и сложности кода; вывод — **QA должен быть первоклассным** в дизайне AI-воркфлоу [arXiv:2511.04427](https://arxiv.org/abs/2511.04427). Это прямой аргумент для глав учебника: чеклисты, тесты, лимиты на автогенерацию, обязательный human review.

## 4. Смежные области для структуры учебника

- **Опыт программирования с ИИ** — обзорные и качественные исследования (например, работы в духе «what is it like to program with AI») помогают главам про когнитивную нагрузку, доверие к подсказкам и совместное рассуждение; в базе уже есть `sarkar2023programming` в `projects.bib`.
- **Мультиагентные паттерны** — для моста OpenClaw ↔ идеи координации агентов (survey по LLM multi-agent, ReAct, Reflexion) — ключи `tran2025multiagent`, `yao2023react`, `shinn2023reflexion`, `wu2023autogen` в общем bib.
- **Инструменты у LLM** — основа для объяснения MCP и tool-use: `schick2023toolformer`.

## 5. Рекомендуемая структура учебника (черновик оглавления)

1. Введение: цели, аудитория, этика и границы ответственности.
2. Cursor: установка, проект, правила, режимы, контекст, ревью.
3. Качество и безопасность: тесты, линтеры, утечки секретов, ограничения моделей; ссылка на эмпирику He et al.
4. OpenClaw: архитектурный обзор, развёртывание, один сквозной сценарий.
5. Связка Cursor + агенты: где код, где оркестратор, как версионировать промпты и конфиги.
6. Приложения: глоссарий, чеклисты, примеры промптов, ссылки на документацию и статьи.

## 6. Model Context Protocol (MCP): зачем в учебнике рядом с OpenClaw и Cursor

**MCP** — открытый протокол (представлен Anthropic в конце 2024), который стандартизует подключение приложений с LLM к внешним **ресурсам, промптам и инструментам** по модели host / client / server (на базе JSON-RPC). Официальная спецификация и версии протокола: [modelcontextprotocol.io](https://modelcontextprotocol.io/specification/latest). Введение и мотивация: [Anthropic — Model Context Protocol](https://www.anthropic.com/research/model-context-protocol).

Для учебника это даёт **общий язык**: OpenClaw и Cursor в продакшен-описаниях опираются на идею подключаемых инструментов; MCP — проверяемый «крючок» для главы про безопасность (согласие пользователя, границы roots, вызов tools), совместимую с `schick2023toolformer` и практикой агентных систем.

## 7. Другая эмпирика: GitHub Copilot и координация в OSS

Чтобы не сводить весь курс к одному инструменту, полезно сослаться на крупную работу по **GitHub Copilot** на данных GitHub: рост вклада на уровне проекта и участия разработчиков сопровождается **ростом времени на координацию** при интеграции кода (~8% в их оценке) и различием эффектов для «ядра» и периферии команды [arXiv:2410.02091](https://arxiv.org/abs/2410.02091). Параллель с He et al. по Cursor: и там речь о **компромиссах скорость/качество/координация** — хороший материал для модуля «критическое мышление» и командных практик code review.

## 8. Бенчмарки «реальных» задач (SWE-bench)

Composer 2 и другие отчёты ссылаются на **SWE-bench** как на оценку исправления issue в репозиториях. В общей библиотеке уже есть `jimenez2024swebench` — имеет смысл выделить в учебнике отдельный подпункт: что именно измеряет бенчмарк, чем он **не** заменяет (стиль, долгосрочная поддерживаемость, командные процессы).

# Следующие шаги

- [ ] Уточнить целевую аудиторию учебника (разработчики / преподаватели / логисты-аналитики).
- [ ] Зафиксировать версии OpenClaw и Cursor, от которых пишется материал.
- [ ] Собрать официальную документацию Cursor и OpenClaw в отдельный раздел «Первоисточники».

# Ссылки

- He et al., эффекты Cursor на velocity и качество: [arXiv:2511.04427](https://arxiv.org/abs/2511.04427)
- Composer 2 Technical Report: [arXiv:2603.24477](https://arxiv.org/abs/2603.24477), [cursor.com/blog](https://cursor.com/blog/composer-2-technical-report)
- OpenClaw (код и релизы): [github.com/openclaw/openclaw](https://github.com/openclaw/openclaw)
- MCP (спецификация): [modelcontextprotocol.io](https://modelcontextprotocol.io/specification/latest)
- Copilot и координация в OSS: [arXiv:2410.02091](https://arxiv.org/abs/2410.02091)

```bibtex
@article{he2026cursorvelocity,
  title   = {Speed at the Cost of Quality: How {Cursor AI} Increases Short-Term Velocity and Long-Term Complexity in Open-Source Projects},
  author  = {He, Hao and Miller, Courtney and Agarwal, Shyam and K{\"a}stner, Christian and Vasilescu, Bogdan},
  journal = {arXiv preprint arXiv:2511.04427},
  year    = {2026},
  note    = {To appear at MSR 2026},
  doi     = {10.48550/arXiv.2511.04427},
  url     = {https://arxiv.org/abs/2511.04427}
}

@misc{cursorresearch2026composer2,
  title         = {Composer 2 Technical Report},
  author        = {{Cursor Research}},
  year          = {2026},
  eprint        = {2603.24477},
  archivePrefix = {arXiv},
  doi           = {10.48550/arXiv.2603.24477},
  url           = {https://arxiv.org/abs/2603.24477}
}

@misc{openclaw2026github,
  title  = {openclaw: OpenClaw agent framework (source repository and releases)},
  author = {{OpenClaw contributors}},
  year   = {2026},
  url    = {https://github.com/openclaw/openclaw},
  note   = {Cite a specific release tag for reproducibility}
}

@misc{anthropic2024mcp,
  title  = {Model Context Protocol specification},
  author = {{Anthropic}},
  year   = {2024},
  url    = {https://modelcontextprotocol.io/specification/latest},
  note   = {Open standard for LLM tool and context integration; revised editions on site}
}

@article{song2025copilotoss,
  title   = {The Impact of Generative {AI} on Collaborative Open-Source Software Development: Evidence from {GitHub Copilot}},
  author  = {Song, Fangchen and Agarwal, Ashish and Wen, Wen},
  journal = {arXiv preprint arXiv:2410.02091},
  year    = {2025},
  doi     = {10.48550/arXiv.2410.02091},
  url     = {https://arxiv.org/abs/2410.02091}
}
```
