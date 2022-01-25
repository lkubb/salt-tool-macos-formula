{#-
    Resets swipe pages touch gesture activation status to default (two fingers).
    This might reset more gestures.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require
  - ..multi_helper.three.clean

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.swipe_pages', 'defined') %}

Swipe Pages touch gesture activation status is reset to default (scroll) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleEnableSwipeNavigateWithScrolls # in Apple Global Domain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
