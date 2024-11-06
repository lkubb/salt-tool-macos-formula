# vim: ft=sls

{#-
    Resets Spotlight index items to defaults.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.spotlight_index", "defined") %}

Spotlight index items are reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.Spotlight
    - name: orderedItems
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

Make sure indexing is enabled for the default volume:
  cmd.wait:  # noqa: 213
    - name: mdutil -i on / > /dev/null
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
