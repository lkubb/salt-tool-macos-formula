{#-
    Customizes display behavior of Clock widget in Menu Bar.

    Values:
        - dict

            * analog: bool [default: false]
            * flash_seconds: bool [default: false]
            * format: string [default: 'EEE HH:mm' for EU]

    .. note::

        This force-sets the format string. It will work, but applying something
        in System Preferences will reset everything. @TODO parse format string
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.clock', 'defined') %}

Display behavior of Clock widget is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.menuextra.clock
    - names:
  {%- if user.macos.menubar.clock.analog is defined %}
        - IsAnalog:
            - value: {{ user.macos.menubar.clock.analog | to_bool }}
            - vtype: bool
  {%- endif %}
  {%- if user.macos.menubar.clock.flash_seconds is defined %}
        - FlashDateSeparators:
            - value: {{ user.macos.menubar.clock.flash_seconds | to_bool }}
            - vtype: bool
  {%- endif %}
  {%- if user.macos.menubar.clock.format is defined %}
        - DateFormat:
            - value: '{{ user.macos.menubar.clock.format }}'
            - vtype: string
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - SystemUIServer was reloaded
{%- endfor %}
