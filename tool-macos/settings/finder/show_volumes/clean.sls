{#-
    Resets display status of /Volumes folder to default (hidden).
    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- if macos.finder is defined and macos.finder.show_volumes is defined %}

Finder display status of /Volumes folder is reset to default (hidden):
  cmd.run:
    - name: |
        chflags hidden /Volumes
    - runas: root
{%- endif %}
