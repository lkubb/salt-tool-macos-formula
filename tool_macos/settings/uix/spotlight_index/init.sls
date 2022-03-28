{#-
    Customizes Spotlight index items.

    Values:
        - array [of items to enable]

            * applications
            * bookmarks-history
            * calculator
            * contacts
            * conversion,
            * definition
            * developer
            * documents
            * events-reminders
            * folders
            * fonts,
            * images
            * mail-messages
            * movies
            * music
            * other
            * pdf
            * presentations,
            * siri
            * spreadsheets
            * system-preferences
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.spotlight_index', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_items with context %}

Spotlight index items are managed for user {{ user.name }}:
  macosdefaults.set:
    - domain: com.apple.Spotlight
    - name: orderedItems
    - value: {{ user_items.values() | list | json }}
    - vtype: array
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Make sure changes are applied before rebuilding the index
      - Make sure indexing is enabled for the default volume
      - Clear Spotlight index for default volume
{%- endfor %}

Make sure changes are applied before rebuilding the index:
  cmd.wait:  # noqa: 213
    - name: killall mds &> /dev/null
    - runas: root
    - watch: []
    - onlyif:
        - pgrep mds

Make sure indexing is enabled for the default volume:
  cmd.wait:  # noqa: 213
    # this might fail if it is run too soon after killing mds
    - name: sleep 1; mdutil -i on / > /dev/null
    - runas: root
    - require:
      - Make sure changes are applied before rebuilding the index
    - watch: []

Clear Spotlight index for default volume:
  cmd.wait:  # noqa: 213
    - name: mdutil -E / > /dev/null
    - runas: root
    - require:
      - Make sure indexing is enabled for the default volume
    - watch: []
