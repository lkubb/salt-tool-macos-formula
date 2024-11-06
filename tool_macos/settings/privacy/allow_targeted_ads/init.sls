# vim: ft=sls

{#-
    Customizes state of targeted ads.

    This probably superseded com.apple.AdLib forceLimitAdTracking (on Monterey?).

    .. note::

        There is still allowIdentifierForAdvertising to be found, but I could not
        find a GUI to set this value.

    Values:
        - bool [default: true - wtf]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.privacy", "defined") | selectattr("macos.privacy.allow_targeted_ads", "defined") %}

State of targeted ads is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AdLib
    - name: allowApplePersonalizedAdvertising
    - value: {{ user.macos.privacy.allow_targeted_ads | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - adprivacyd was reloaded # maybe?
      - cfprefsd was reloaded # there is probably more
{%- endfor %}
