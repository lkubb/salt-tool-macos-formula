{#-
    Resets NightShift behavior to defaults.

    References:
      https://web.archive.org/web/20200316123016/https://github.com/aethys256/notes/blob/master/macOS_defaults.md
      https://www.reddit.com/r/osx/comments/6334ac/toggling_night_shift_from_script/
      https://github.com/LukeChannings/dotfiles/blob/main/install.macos#L418-L438
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.display', 'defined') | selectattr('macos.display.nightshift', 'defined') %}

NightShift settings are reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - name: CBUser-{{ user.guid }}
    - domain: com.apple.CoreBrightness
    # this needs to be run as root since the file is
    # /var/root/Library/Preferences/com.apple.CoreBrightness.plist
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - corebrightnessd was reloaded
{%- endfor %}
