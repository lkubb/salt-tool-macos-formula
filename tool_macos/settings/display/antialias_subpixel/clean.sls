# vim: ft=sls

{#-
    Resets subpixel antialiasing behavior to default (disabled since 10.11/Mojave).

    References:
      https://apple.stackexchange.com/questions/382818/what-do-setting-cgfontrenderingfontsmoothingdisabled-from-defaults-actually-do
      https://apple.stackexchange.com/questions/337870/how-to-turn-subpixel-antialiasing-on-in-macos-10-14
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.antialias_subpixel", "defined") %}

Subpixel anti-aliasing is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: CGFontRenderingFontSmoothingDisabled # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
