# Skill Changelog

> История изменений скиллов по циклам reflect → improve.
> Обновляется автоматически в Шаге 3 скилла `improve`.
> Используется в Шаге 1.5 `improve` для анализа нестабильности и конфликтов.

Формат: `YYYY-MM-DD | skill-name | суть изменения | источник`

---

2026-03-10 | design-master | Добавлен Step 0: аудит существующего UX/UA + 2–3 концептуальных направления перед переходом к стилю | строка коррекции пользователя
2026-03-10 | reflect | Шаг 1.4: добавлен py -3 однострочник для Windows без git repo (вместо ls -lt) | трение из reflection
2026-03-10 | vps-verify | Создан новый скилл: post-deploy верификация HTTP + HTML-элементов | новый скилл из reflection
2026-03-10 | CLAUDE.md (global) | Правило 1: добавлен шаг 1.5 — grep hard-problems по стеку проекта при старте | SIL улучшение (пункт A)
2026-03-10 | CLAUDE.md (global) | Dispatch: добавлен триггер для vps-verify | SIL улучшение (пункт B1)
2026-03-10 | improve | Шаг 3б: добавлен обязательный шаг — проверить dispatch-таблицу при создании нового скилла | SIL улучшение (пункт B2)
2026-03-10 | design-master | Step 0б: структура A/B/C направлений — C обязательно деструктивное, ломает главную сущность | SIL улучшение (пункт C)
2026-03-10 | sil (команда) | Добавлен Блок 5б Прогресс: improve-циклы, changelog stats, нестабильный скилл сигнал | SIL улучшение (пункт D)
2026-03-10 | intake | OUTPUT TEMPLATE: new AI-optimized format — English, QUICK CONTEXT, INFRA line, dense LOG | SIL улучшение (пункт E)
2026-03-10 | migrate-claude-md | Добавлены шаги: QUICK CONTEXT, INFRA, session log compression, ADR→docs/adr.md | SIL улучшение (пункт E)
2026-03-10 | sil (команда) | Блок 2: проверка размера CLAUDE.md >150 строк, QUICK CONTEXT, INFRA | SIL улучшение (пункт E)
2026-03-11 | vps-verify | Шаг 2.5: проверка /api/status (app-level health) до HTTP-проверок страниц | строка коррекции "работа с сервером"
2026-03-11 | vps-verify | Шаг 4.5: verify new code in container (docker exec grep) — диагностика старого baked image | трение из reflection
2026-03-11 | docker-deploy | Создан новый скилл: полный deploy цикл для baked-image Docker (sync→build→up→verify→health) | новый скилл из reflection
2026-03-11 | cross-cutting-principles | P7 Applicability Check: перед реализацией внешней фичи — явная проверка применимости к системе | строка коррекции
2026-03-11 | weekly-review | Ось 4: добавлен анализ ⚠️ Review в index.md — скиллы с ❌-историей помечаются [ПРИОРИТЕТ IMPROVE] | предложение из reflection-19
2026-03-11 | migrate-claude-md | Добавлена секция Batch Mode — применение правил к N файлам без per-file подтверждений | трение из reflection-20
2026-03-12 | intake | OUTPUT TEMPLATE: убрана секция ## PHASES из CLAUDE.md; добавлена строка PLAN → plan.md в QUICK CONTEXT; добавлен шаблон plan.md с YAML frontmatter и строгим форматом заголовков; обновлены checklist и final message | архитектурное улучшение — вынос плана в отдельный файл
2026-03-12 | reflect | Step 1: добавлено чтение plan.md (frontmatter + открытые задачи); Step 5: алгоритм обновления plan.md (чекбоксы, автопереход фаз, дата) и отдельно CLAUDE.md (лог); PRE-SAVE CHECKLIST разделён на plan.md и CLAUDE.md | архитектурное улучшение — вынос плана в отдельный файл
2026-03-12 | CLAUDE.md (global) | Rule 1: добавлен шаг 1.3 — чтение plan.md при старте сессии, вывод активной фазы и числа открытых задач; Rule 5: конкретизировано что писать в plan.md vs CLAUDE.md | архитектурное улучшение — вынос плана в отдельный файл
2026-03-12 | migrate-claude-md | Step 1: добавлена категория "ПЛАН" в список несоответствий; NEW FORMAT RULES: добавлено правило PHASES→plan.md (конвертация формата, определение active_phase, удаление секции из CLAUDE.md) | поддержка миграции существующих проектов
2026-03-12 | [migration] sil-v2 | PHASES→plan.md (7 фаз, все done); PLAN: → plan.md в QUICK CONTEXT | migrate-claude-md
2026-03-12 | [migration] SIL | PHASES→plan.md (шаблонные фазы); Plan: в STATUS | migrate-claude-md
2026-03-12 | [migration] Ethersensor | PHASES→plan.md (5 фаз, Phase 2 active); Plan: в State строке | migrate-claude-md
2026-03-12 | [migration] CohaerenceOFM | PHASES→plan.md (5 фаз, Phase 1 active); Plan: в STATUS | migrate-claude-md
2026-03-12 | [migration] osint-framework | PLAN.md конвертирован в machine-readable формат (5 фаз); архитектурный контент сохранён в docs/stages.md | migrate-claude-md
2026-03-12 | [migration] polymarket-insider | STAGES→plan.md (Phase 13 active); PLAN: → plan.md в QUICK CONTEXT | migrate-claude-md
2026-03-12 | cross-cutting-principles | P6 обновлён: CLAUDE.md → plan.md + CLAUDE.md разделение; P8 добавлен: English docs + YAML where appropriate + Progressive Context | архитектурное улучшение
2026-03-13 | reflect | Step 5: при закрытии фазы (Phase N → done) добавлено предложение запустить /strategic-review | трение из reflection-22
2026-03-13 | strategic-review | Создан новый скилл: стратегический анализ сервиса (baseline / diagnosis / 5 areas / priority matrix / roadmap) | новый скилл из reflection-22
2026-03-13 | CLAUDE.md (global) | Rule 4: добавлен триггер для strategic-review | новый скилл из reflection-22
2026-03-13 | cross-cutting-principles | P9 добавлен: Ask on External Access Failure — при 403/404 не перебирать альтернативы | строка коррекции
2026-03-13 | user-preferences | Work patterns: prefers file directly on inaccessible URL | строка коррекции
2026-03-13 | semantic/patterns | rsim pattern distilled from 3 episodic entries (evaluate-extract, skill-install, merge-install) | distillation
2026-03-13 | CLAUDE.md (global) | Rule 1 step 2: при отсутствии CLAUDE.md — сканировать инфра-файлы (update.py, deploy.py, .env, Caddyfile, Makefile, docker-compose.yml) | строка коррекции
2026-03-13 | docker-patterns | Добавлен раздел Multi-Compose Caddy Proxying: найти сеть Caddy → network connect → container name в Caddyfile | трение из reflection

