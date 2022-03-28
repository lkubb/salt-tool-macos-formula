{#-
    Customizes display status of /Volumes folder.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- if macos.finder is defined and macos.finder.show_volumes is defined %}

Finder display status of /Volumes folder is managed:
  cmd.run:
    - name: |
        if [ -n '{{ 'yes' if macos.finder.show_volumes }}' ]; then
          chflags nohidden /Volumes
        else
          chflags hidden /Volumes
        fi
    - runas: root
{%- endif %}
