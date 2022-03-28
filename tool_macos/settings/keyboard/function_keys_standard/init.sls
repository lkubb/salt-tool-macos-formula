{#-
    Customizes default state of function keys. Enabling this will
    make F1 to F12 behave like standard F1 to F12, not as system function keys.

    .. note::

        You might need to reboot after applying.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.keyboard', 'defined') | selectattr('macos.keyboard.function_keys_standard', 'defined') %}

Default state of function keys is managed for {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.keyboard.fnState  # in NSGlobalDomain
    - value: {{ user.macos.keyboard.function_keys_standard | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
