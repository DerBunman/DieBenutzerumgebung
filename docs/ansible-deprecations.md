# Ansible-Deprecation-Analyse

Stand: aktuelle Repository-Version (ohne Ausführung von Ansible, da `ansible-playbook` im Container nicht installiert ist).

## 1) Klar deprecated

### `include` in Tasks
In mehreren Rollen wird noch das alte `include:` verwendet. Das gilt in modernem Ansible als veraltete Schreibweise und sollte aufgeteilt werden in:

- `include_tasks` (dynamisch)
- `import_tasks` (statisch)

Vorkommen:

- `roles/common/tasks/main.yml`
- `roles/desktop/tasks/main.yml`
- `roles/desktop/tasks/i3.yml`
- `roles/system/tasks/main.yml`

## 2) Deprecated in `ansible.cfg`

### `callback_whitelist`
In `ansible.cfg` wird `callback_whitelist = default` gesetzt. Die Option ist veraltet; modern ist `callbacks_enabled`.

## 3) Legacy-Stil (nicht zwingend deprecated, aber modernisierungswürdig)

### Freiform/Key-Value-Syntax in Modulen
Es gibt noch alte Freiform-Aufrufe wie:

- `service: name=ssh state=restarted`
- `lineinfile`-Parameter im `key=value`-Stil (`dest=...`, `regexp=...`, ...)
- `local_action: stat path=secrets.yml`

Diese funktionieren oft noch, sind aber schlechter wartbar als YAML-Mapping-Syntax.

Empfehlung:

- `service:` als strukturierte Parameter schreiben (`name:`, `state:`)
- `lineinfile` ausschließlich mit YAML-Keys (`path:`, `regexp:`, `line:`, `state:`)
- `local_action` durch normale Task-Syntax plus `delegate_to: localhost` und ggf. `run_once: true` ersetzen

## 4) Priorisierte Migrationsreihenfolge

1. Alle `include:`-Aufrufe ersetzen (höchste Priorität).
2. `callback_whitelist` auf `callbacks_enabled` umstellen.
3. Legacy-Freiformsyntax vereinheitlichen (technische Schuld reduzieren).

## 5) Hinweis zur Validierung

Eine automatische Deprecation-Prüfung konnte in dieser Umgebung nicht ausgeführt werden, da weder `ansible-playbook` noch `ansible-lint` installiert sind.
