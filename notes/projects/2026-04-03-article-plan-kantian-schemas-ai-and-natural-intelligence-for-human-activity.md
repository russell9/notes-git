---
title: "Article plan: Kantian Schemas, AI and natural Intelligence for human activity"
tags: [projects, articles]
created: 2026-04-03
updated: 2026-04-03
status: draft
hub_research_applied: true
hub_research_applied_at: 2026-04-03
---

# @context

**Title:** Article plan: Kantian Schemas, AI and natural Intelligence (NI) for human activity.

Исходная постановка: статья о **кантианских схемах** в связке **ИИ и естественного интеллекта (NI)** применительно к **решению задач человеческой деятельности**. В черновике «Контекст» зафиксирована эта формулировка на английском; раздел «Основное» был пуст. Контекст берётся **только из этого файла**.

# Контекст

Article about Kantian schemas in the system of AI and natural intelligence (NI) for human activity problems solving. The planned article should bridge **transcendental philosophy** (how a priori rules connect concepts to experience), **cognitive science** (schemas as procedural templates, developmental and cultural mediation), and **AI systems** (neurosymbolic structure, limits of end-to-end learning), with an explicit hook to **activity-centered** views of human work and problem solving.

## @goal

Собрать **исследовательский каркас** для статьи: (1) уточнить кантианское различие **category / schema / schematism** и его современные прочтения; (2) связать это с **NI** (человек, культура, развитие навыков) и с **AI** (символы, правила, обучение); (3) указать **проверяемые источники** (классика, когнитивистика, neurosymbolic AI, activity theory); (4) намечено **оглавление** и линия аргументации для журнала/главы монографии.

# Основное

## 1. Kant: categories, schemata, and schematism

In the *Critique of Pure Reason*, **categories** are pure concepts of the understanding; **transcendental schemata** are the time-ordered rules (mediated by imagination) that allow categories to apply to appearances. **Schematism** names the chapter-level problem: how intellectual and sensible manifolds are jointly articulated. Secondary literature often stresses that schemata are **procedures** or **rules for synthesis**, not mental pictures—this is a useful bridge to computational “schemas” and to skill-based NI.

- Primary anchor: CPR B-edition, Analytic of Principles (Schematism).
- Philosophical depth: Longuenesse’s reading ties categories and **reflective judgment** to the capacity to judge in empirical contexts.

## 2. From Kant to cognitive science and “natural intelligence”

NI here means **biological–cultural cognition**: perception–action loops, development (Piagetian-style schema evolution as a historical parallel, not identity with Kant), social and tool **mediation**. Cognitive science uses “schema” more loosely (frames, scripts); the article should **disambiguate** Kantian *Schema* vs. psychological “schema,” while arguing for a **family resemblance** at the level of **rule-governed application** of concepts to cases.

Lake et al. argue for **compositional, model-based** ingredients as part of human-like learning—relevant when you claim NI brings structure that pure statistical scaling under-specifies.

## 3. AI: where Kantian structure still matters

- **Neurosymbolic AI** (survey: Garcez et al.) provides a vocabulary for combining symbolic constraints with learning—parallel to the philosophical need to relate **rules** and **data**.
- **LLM-era caveat**: large models excel at pattern completion; Kantian questions about **grounding**, **normativity**, and **objectivity** map onto debates on hallucination, alignment, and evaluation beyond coherence.

Use `garcez2023neurosymbolic` from the shared `projects.bib` as the main AI-theory anchor unless you add newer 2025–2026 surveys.

## 4. Human activity (деятельность)

For “human activity problem solving,” **cultural-historical activity theory** (e.g., Engeström) supplies **mediation by tools and signs**, division of labor, and object-oriented activity—useful when NI is not individual brains only but **systems of activity**. The article can position Kantian schemata as a **micro-level** account of rule application and activity theory as a **meso/macro** account of how problems are socially and instrumentally structured.

## 5. Suggested article arc (outline)

1. Introduction: why Kantian schemata for AI + NI + activity now.
2. Exposition: categories, schemata, imagination, time (compact, citation-heavy).
3. NI: cognitive and cultural mediation; disambiguation of “schema.”
4. AI: neurosymbolic hooks; limits of end-to-end learning for norm-governed activity.
5. Synthesis: schemata as **interface** between normative structure and situated practice.
6. Implications: design of human–AI systems in real work settings; open problems.

## 6. Perspectives

- Interdisciplinary venues: philosophy of AI, cognitive science, HCI / CSCW (activity), theoretical CS / neurosymbolic workshops.
- Risk: superficial “Kant metaphor” — counter with precise textual anchors and clear analogies **as analogies**.

# Следующие шаги

- [ ] Choose target venue (philosophy / cognitive science / AI ethics / HCI).
- [ ] Add 2–3 case studies of **instrumented human activity** (e.g., logistics, design, research workflows).
- [ ] Draft §3 with explicit glossary: Category / Schema / NI / Activity / Tool mediation.

# Ссылки

- Kant, *Critique of Pure Reason* (Guyer & Wood trans., Cambridge).
- Longuenesse, *Kant and the Capacity to Judge* (Princeton).
- Lake et al., “Building machines that learn and think like people,” *BBS* 2017.
- Engeström, *Learning by Expanding* (activity-theoretical developmental research).
- Garcez et al., “Neurosymbolic AI: The 3rd Wave,” *Artificial Intelligence Review* 2023 (already in `projects.bib`).

```bibtex
@book{kant1998cpr,
  author    = {Kant, Immanuel},
  title     = {Critique of Pure Reason},
  editor    = {Guyer, Paul and Wood, Allen W.},
  publisher = {Cambridge University Press},
  address   = {Cambridge},
  year      = {1998},
  note      = {English translation of 1781/1787 work; see B-edition pagination in margins}
}

@book{longuenesse1998capacity,
  author    = {Longuenesse, B{\'e}atrice},
  title     = {Kant and the Capacity to Judge},
  publisher = {Princeton University Press},
  address   = {Princeton, NJ},
  year      = {1998}
}

@article{lake2017building,
  title   = {Building machines that learn and think like people},
  author  = {Lake, Brenden M. and Ullman, Tomer D. and Tenenbaum, Joshua B. and Gershman, Samuel J.},
  journal = {Behavioral and Brain Sciences},
  volume  = {40},
  year    = {2017},
  doi     = {10.1017/S0140525X16001837},
  url     = {https://doi.org/10.1017/S0140525X16001837}
}

@book{engestrom1987learning,
  author    = {Engestr{\"o}m, Yrj{\"o}},
  title     = {Learning by Expanding: An Activity-Theoretical Approach to Developmental Research},
  publisher = {Orienta-Konsultit},
  address   = {Helsinki},
  year      = {1987}
}
```
