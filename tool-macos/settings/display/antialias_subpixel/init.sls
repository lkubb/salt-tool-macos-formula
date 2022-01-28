{#-
    Customizes subpixel antialiasing behavior.

    Values:
        - bool [default: false since MacOS Mojave 10.11]

    References:
        * https://apple.stackexchange.com/questions/382818/what-do-setting-cgfontrenderingfontsmoothingdisabled-from-defaults-actually-do
        * https://apple.stackexchange.com/questions/337870/how-to-turn-subpixel-antialiasing-on-in-macos-10-14
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.display', 'defined') | selectattr('macos.display.antialias_subpixel', 'defined') %}

Subpixel anti-aliasing is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: CGFontRenderingFontSmoothingDisabled # in NSGlobalDomain
    {#- Mind that the actual setting is called "...Disabled". For consistency,
    the pillar value is inverted. pillar False => disabled True #}
    - value: {{ False == user.macos.display.antialias_subpixel | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
