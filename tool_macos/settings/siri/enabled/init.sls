{#-
    Customizes Siri activation status.

    .. note::

        Note that System Preferences does much more when toggling
        the option. This might be very incomplete.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.siri', 'defined') | selectattr('macos.siri.enabled', 'defined') %}

Ask Siri activation status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.assistant.support
    - name: Assistant Enabled
    - value: {{ user.macos.siri.enabled | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
