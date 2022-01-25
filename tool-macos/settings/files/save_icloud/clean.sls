{#-
    Resets default "Save as" location of save panel to defaults (iCloud).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.files', 'defined') | selectattr('macos.files.save_icloud', 'defined') %}

Default Save As location is reset to default (iCloud) for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSDocumentSaveNewDocumentsToCloud # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
