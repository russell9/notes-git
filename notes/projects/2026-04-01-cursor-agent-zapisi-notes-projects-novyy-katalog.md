---
title: "Можно ли настроить агента CURSOR для обхода projects и выполнения подготовленного действия над записями с сохранением новой директории"
tags: [planning, backend, Agents, OpenClaw]
created: 2026-04-01
updated: 2026-04-01
status: draft
previous_filename: 2026-04-01-mozhno-li-nastroit-agenta-cursor-dlya-obkhoda-projects-i-vypolneniya-podgotovlennogo-deystviya-nadzapisyami-s-sokhraneniem-novoy-direktorii.md
parents: []
related:
  - ./2026-04-01-tip-myshleniya-agentov-literatura-openclaw.md
---

# @context

В YAML у этой заметки поле `parents` пустое; по смыслу связи с веткой про агентов ниже зафиксирован **тот же родительский контекст**, что и у соседних дочерних заметок — [2026-04-01-tip-myshleniya-agentov-literatura-openclaw.md](2026-04-01-tip-myshleniya-agentov-literatura-openclaw.md).

**Родительский title (связанная ветка):** «Найти варианты создания агентов с разным типом мышления».

**Родительское тело (фрагмент «Основное»):**

Ниже — рабочая классификация типов агентного мышления и встраивание в `OpenClaw` через provider-плагины, tool/skill-плагины и внешний оркестратор; архитектура: ядро LLM + маршрутизация + память; модули symbolic / bayesian / causal / axiology / social; контур Plan → Act → Critique → Align → Commit; policy-gate до действий.

**Локальный контекст этой заметки (собственная формулировка задачи):** настройка агента в Cursor для пакетной обработки записей в `notes/projects`, вывода в новый каталог или переименования с сохранением ссылок на исходные файлы; ограничения workspace и политики инструментов.

## @goal

Исследовать тему: **IDE-ориентированные ИИ-ассистенты**, **границы workspace/проекта**, **пакетные операции с файлами** и **опыт разработчиков** при работе с генеративными помощниками. Найти литературу и смежные направления (бенчмарки на уровне репозитория, HCI, безопасность). Результат — в «Основное»; библиография — в «Ссылки» (BibTeX).

# Контекст

См. **@context**: связка «агентные архитектуры / tools» + практическая задача по Cursor и каталогам заметок.

# Основное

## Выводы исследования

**1. Граница workspace — не «ограничение характера», а модель доверия.** Ассистент в IDE оперирует контекстом открытого проекта; произвольный доступ ко всей файловой системе противоречит типичной модели угроз (утечки, случайные перезаписи). Практический вывод для вашей задачи: **открыть общий корень** (или добавить папку в workspace), куда входят и исходные `notes/projects`, и целевой каталог — это стандартный способ «легально» расширить область действия агента без обхода политики.

**2. Агент как цикл «рассуждение + инструмент».** Родительский контекст (ReAct-подобные паттерны, tools) переносится на Cursor: надёжнее описать **повторяемый сценарий** (скрипт + правила в `.cursor/rules`), чем рассчитывать на разовые «обходы». Пакетная обработка заметок хорошо стыкуется с **детерминированным постобработчиком** (переименование, frontmatter, ссылки), а LLM — с ролями классификации/рефайминга текста.

**3. Литература про опыт программирования с LLM.** Работы вроде Sarkar et al. анализируют, чем LLM-помощь похожа на компиляцию, парное программирование и поиск по коду, и какие **новые издержки** появляются: формулировка запроса, проверка и отладка сгенерированного. Это смежно с вашей целью «подготовленное действие над записями»: важны **проверяемость** (diff, git) и **явные ссылки** parent/child в метаданных.

**4. Смежные области и перспективы.**  
- **Репозиторный уровень (SWE-bench и аналоги):** оценка агентов на реальных задачах в кодовой базе — перспектива тех же паттернов для «литературного» или «заметочного» репозитория (тесты на целостность ссылок, frontmatter).  
- **Оркестрация агентов (multi-agent surveys):** если позже понадобится несколько ролей (классификатор, рерайтер, linker), обзоры по MAS дают таксономию координации; для заметок часто достаточно одного агента + скриптов.  
- **Безопасность и аудит:** policy-gate из родительского контекста применим к «массовым» правкам файлов (запрет удаления без подтверждения, allowlist путей).

**5. Итог по исходному вопросу:** полностью «отключить» привязку к projects нельзя без изменения продукта; **расширить workspace**, **закрепить сценарий в rules**, **вынести массовые операции в скрипт** — согласованная и литературно обоснуемая стратегия.

# Следующие шаги

- [ ] Добавить в репозиторий заметок шаблон frontmatter (`parents`, `previous_filename`) и, при необходимости, скрипт проверки битых ссылок.
- [ ] В `.cursor/rules` описать корень workspace и запрет на выход за пределы `notes-git/`.

# Ссылки

```bibtex
@article{sarkar2023programming,
  title   = {What is it like to program with artificial intelligence?},
  author  = {Sarkar, Advait and Gordon, Andrew D. and Negreanu, Carina and Poelitz, Christian and Ragavan, Sruti Srinivasa and Zorn, Ben},
  journal = {arXiv preprint arXiv:2208.06213},
  year    = {2023},
  note    = {Also presented at PPIG 2022}
}

@inproceedings{jimenez2024swebench,
  title     = {{SWE}-bench: Can Language Models Resolve Real-World {GitHub} Issues?},
  author    = {Jimenez, Carlos E. and Yang, John and Wettig, Alexander and Yao, Shunyu and Pei, Kexin and Press, Ofir and Narasimhan, Karthik},
  booktitle = {International Conference on Learning Representations},
  year      = {2024},
  url       = {https://arxiv.org/abs/2310.06770}
}

@inproceedings{yao2023react,
  title     = {ReAct: Synergizing Reasoning and Acting in Language Models},
  author    = {Yao, Shunyu and Zhao, Jeffrey and Yu, Dian and Du, Nan and Shafran, Izhak and Narasimhan, Karthik and Cao, Yuan},
  booktitle = {International Conference on Learning Representations},
  year      = {2023},
  url       = {https://arxiv.org/abs/2210.03629}
}

@article{tran2025multiagent,
  title   = {Multi-Agent Collaboration Mechanisms: A Survey of {LLMs}},
  author  = {Tran, Khanh-Tung and Dao, Dung and Nguyen, Minh-Duong and Pham, Quoc-Viet and O'Sullivan, Barry and Nguyen, Hoang D.},
  journal = {arXiv preprint arXiv:2501.06322},
  year    = {2025}
}
```
