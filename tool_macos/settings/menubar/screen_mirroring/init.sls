{#-
    Customizes display status of Screen Mirroring widget in Menu Bar.

    Values:
        - when_active [default: when_active]
        - or bool
-#}

{#- Was found as showInMenuBarIfPresent in com.apple.airplay. #}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.screen_mirroring', 'defined') %}
  {%- if user.macos.menubar.screen_mirroring in [True, False] %}
    {%- set status = 18 if user.macos.menubar.screen_mirroring else 8 %}
  {%- elif 'when_active' == user.macos.menubar.screen_mirroring %}
    {%- set status = 2 %}
  {%- else %}
    {%- do salt['log.error']("Invalid value '{}' specified for macos.menubar.screen_mirroring for user {}!".format(user.macos.menubar.sound, user.name)) %}
  {%- endif %}
Display status of Screen Mirroring widget in Menu Bar is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.controlcenter
    - name: ScreenMirroring
    - value: {{ status | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do
{%- endfor %}
