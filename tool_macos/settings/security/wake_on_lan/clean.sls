{#-
    Resets state of Wake-on-LAN to defaults.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- if macos.security is defined and macos.security.wake_on_lan is defined %}

Wake-on-LAN state is reset to defaults (ac=enabled):
  pmset.set:
    - scope: ac
    - name: womp
    - value: 1

Wake-on-LAN state is reset to defaults (battery=disabled):
  pmset.set:
    - scope: battery
    - name: womp
    - value: 0
{%- endif %}
