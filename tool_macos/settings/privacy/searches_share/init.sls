# vim: ft=sls

{#-
    Customizes whether search queries from Safari, Siri, Spotlight, Lookup
    and others are sent to Apple to be stored.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.privacy", "defined") | selectattr("macos.privacy.searches_share", "defined") %}

Searches sharing status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.assistant.support
    - name: Search Queries Data Sharing Status
    - value: {{ 1 if user.macos.privacy.searches_share else 2 }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded # there is probably more
{%- endfor %}
