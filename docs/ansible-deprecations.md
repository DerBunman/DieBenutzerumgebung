# Ansible-Deprecation-Analyse

Diese Datei wurde im Zuge der Modernisierung aktualisiert.

## Behobene Deprecations

- Veraltete `include:`-Statements wurden ersetzt durch `import_tasks` bzw. `include_tasks`.
- Veraltete `callback_whitelist`-Konfiguration wurde durch `callbacks_enabled` ersetzt.

## Zusätzlich modernisiert (Legacy-Stil)

- `local_action` wurde auf reguläre Tasks mit `delegate_to: localhost` umgestellt.
- Freiform `key=value`-Syntax in `lineinfile` und `service` wurde auf YAML-Mapping umgestellt.

## Hinweis

Eine Runtime-Validierung per `ansible-playbook`/`ansible-lint` ist in dieser Umgebung weiterhin nicht möglich, da die Tools nicht installiert sind.
