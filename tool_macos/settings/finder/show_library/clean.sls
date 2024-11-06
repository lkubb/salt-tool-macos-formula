# vim: ft=sls

{#-
    Resets display status of ~/Library folder to default (hidden).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.show_library", "defined") %}

Display status of ~/Library is reset to default (hidden) for user {{ user.name }}:
  cmd.run:
    - name: |
        chflags hidden {{ user.home }}/Library
        xattr -wx com.apple.FinderInfo \
          '0000000000000000400000000000000000000000000000000000000000000000' \
          {{ user.home }}/Library
    - runas: {{ user.name }}
{%- endfor %}
