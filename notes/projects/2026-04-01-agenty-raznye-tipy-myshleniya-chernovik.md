---
title: "Как использовать агентов с разным типом мышления"
tags: [test, slug, ru]
created: 2026-04-01
updated: 2026-04-01
status: draft
previous_filename: 2026-04-01-kak-ispolzovat-agentov-s-raznym-tipom-myshleniya.md
parents:
  - ./2026-04-01-tip-myshleniya-agentov-literatura-openclaw.md
---

# @context

Ниже — **title** и **тело** родительской заметки [2026-04-01-tip-myshleniya-agentov-literatura-openclaw.md](2026-04-01-tip-myshleniya-agentov-literatura-openclaw.md) (раздел «Основное»), зафиксированные как контекст для этой дочерней заметки.

**Родительский title:** «Найти варианты создания агентов с разным типом мышления».

**Родительское тело (фрагмент «Основное»):**

Ниже — рабочая классификация (не абсолютно исчерпывающая, но покрывает основные линии из литературы) и как это обычно встраивают в `OpenClaw`.

- Типы: символические (GOFAI), статистические (RL/MDP), байесовские, причинно-следственные (SCM), LLM-агенты (CoT, tool use), нейросимволические гибриды, аксиологические/моральные ограничения, социализированные multi-agent, эмбодид, экономические/игровые модели.
- Интеграция в OpenClaw: provider-плагин под «движок» рассуждения; tool/skill-плагины под специализированные модули (`symbolic_planner`, `bayes_updater`, и т.д.); внешний оркестратор как сервис с тонким адаптером.
- Архитектура: ядро LLM + маршрутизация + память; подключаемые модули по типам; контур Plan → Act → Critique → Align → Commit; policy-gate до действий.

## @goal

Выполнить исследование по теме: **как на практике сочетать разные типы мышления** (символика, вероятность, причинность, LLM, нормы) **в одной агентной системе**: паттерны интеграции, доверие и объяснимость, ограничения. Найти литературу (в т.ч. обзорную), смежные области и перспективы.

# Контекст

Дочерняя заметка использует **@context** и **@goal** для перехода от классификации типов к вопросу «как это собрать вместе».

# Основное

## Выводы исследования

**1. Нейросимволический слой как «клей» между типами мышления.** Обзорные работы по neurosymbolic AI описывают третью волну систем, где **обучение** (нейросети) сочетается с **явным знанием и логическим выводом**. Это соответствует родительской идее: LLM не обязан *внутри себя* имитировать PDDL или SCM — достаточно стабильного интерфейса к символическому решателю, байесовскому обновлению или causal-query API.

**2. Инструментальный слой = типы мышления как сервисы.** ReAct и последующие agentic-рамки показывают, что **один** LLM-контроллер может вызывать разнородные действия (поиск, код, калькулятор). В вашей таксономии это естественно отображается на **tool/provider**: «байесовское мышление» — не отдельный чат-бот, а модуль с контрактом вход/выход/uncertainty.

**3. Ценности, этика, социальные нормы — не отдельный «тип LLM», а ограничения на траекторию.** Литература по value alignment и safety-слоям согласуется с родительским **policy-gate**: классификатор/правила/конституционные промпты проверяют план *до* действий. Смежность с **деонтической логикой** и **multi-agent norms** — перспектива явно кодировать нормы как проверяемые ограничения поверх любого сочетания модулей.

**4. Смежные области и перспективы.**  
- **Causal + LLM:** активная область (интервенции, контрфактуалы) — перспектива tool «causal_query» с формальной семантикой, а не свободный текст.  
- **Верификация планов:** символический планировщик + LLM для целей и предпосылок — классический гибрид.  
- **Объяснимость и аудит:** единый trace (thought/action/tool-result) упрощает отладку по сравнению с непрозрачным мультиагентным чатом.

**5. Практическая схема под OpenClaw (из @context):** типы мышления → **каталог tools/providers** с общим форматом ответа (уверенность, объяснение, ссылки на артефакты); ядро LLM отвечает за **маршрутизацию** и **сборку** ответа; policy-gate и внешний оркестратор — для жёстких или регулируемых контуров.

# Следующие шаги

- [ ] Задать минимальный контракт для каждого типа модуля (JSON schema, обязательные поля: `result`, `confidence`, `trace_id`).
- [ ] Прототип: 2 типа (например LLM + symbolic stub) и один policy-gate на «запрещённые действия».

# Ссылки

```bibtex
@article{garcez2023neurosymbolic,
  title   = {Neurosymbolic {AI}: The 3rd Wave},
  author  = {Garcez, Artur S. d'Avila and Lamb, Luis C.},
  journal = {Artificial Intelligence Review},
  volume  = {56},
  pages   = {12387--12406},
  year    = {2023},
  publisher = {Springer},
  doi     = {10.1007/s10462-023-10448-w}
}

@inproceedings{yao2023react,
  title     = {ReAct: Synergizing Reasoning and Acting in Language Models},
  author    = {Yao, Shunyu and Zhao, Jeffrey and Yu, Dian and Du, Nan and Shafran, Izhak and Narasimhan, Karthik and Cao, Yuan},
  booktitle = {International Conference on Learning Representations},
  year      = {2023},
  url       = {https://arxiv.org/abs/2210.03629}
}

@inproceedings{schick2023toolformer,
  title     = {Toolformer: Language Models Can Teach Themselves to Use Tools},
  author    = {Schick, Timo and Dwivedi{-}Yu, Jane and Dess{\`i}, Roberto and Raileanu, Roberta and Lomeli, Maria and Hambro, Eric and Zettlemoyer, Luke and Cancedda, Nicola and Scialom, Thomas},
  booktitle = {Advances in Neural Information Processing Systems},
  year      = {2023},
  volume    = {36},
  url       = {https://arxiv.org/abs/2302.04761}
}

@article{tran2025multiagent,
  title   = {Multi-Agent Collaboration Mechanisms: A Survey of {LLMs}},
  author  = {Tran, Khanh-Tung and Dao, Dung and Nguyen, Minh-Duong and Pham, Quoc-Viet and O'Sullivan, Barry and Nguyen, Hoang D.},
  journal = {arXiv preprint arXiv:2501.06322},
  year    = {2025}
}
```
