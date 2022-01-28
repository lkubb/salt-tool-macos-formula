{#-
    Customizes default "Save as" location of save panel (iCloud vs local).

    Values:
        - bool [default: true = iCloud]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.files', 'defined') | selectattr('macos.files.save_icloud', 'defined') %}

Default Save As location is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSDocumentSaveNewDocumentsToCloud # in NSGlobalDomain
    - value: {{ user.macos.files.save_icloud | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
