{#-
    Customizes system theme.

    .. note::

        Currently needs a logout to apply.

    Values:
        - string [default: light]

            * dark
            * light
            * auto
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.theme', 'defined') %}
  {%- set u = user.macos.uix.theme %}
System theme is managed for user {{ user.name }}:
  macosdefaults.write:
    - names:
        {#- I totally made "Light" up - MacOS actually deletes the key. #}
        - AppleInterfaceStyle:
            - value: {{ u | capitalize if u in ['light, dark'] else 'Dark' }}
            - vtype: string
        - AppleInterfaceStyleSwitchesAutomatically:
            - value: {{ u == 'auto' }}
            - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
