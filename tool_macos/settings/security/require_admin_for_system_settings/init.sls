# vim: ft=sls

{#-
    Customizes the requirement to authenticate as an admin to change
    system-wide settings.

    Values:
        - bool [default: true]

    References:
        * https://github.com/SummitRoute/osxlockdown/blob/master/commands.yaml
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.require_admin_for_system_settings is defined %}
{#-   the setting is called 'shared', so we need to invert #}
{%-   set m = 'false' if macos.security.require_admin_for_system_settings else 'true' %}

Requirement to authenticate as an admin to change system-wide settings is managed:
  cmd.run:
    - name: |
        security authorizationdb read system.preferences > /tmp/system.preferences.plist && \
        /usr/libexec/PlistBuddy -c "Set :shared {{ m }}" /tmp/system.preferences.plist && \
        security authorizationdb write system.preferences < /tmp/system.preferences.plist
    - unless:
      - |
          security authorizationdb read system.preferences 2> /dev/null | \
          grep -A1 shared | grep -E '(true|false)' | grep '{{ m }}'
    - require:
      - System Preferences is not running
{%- endif %}
