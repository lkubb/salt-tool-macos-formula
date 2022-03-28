{#-
    Resets the requirement to authenticate as an admin to change
    system-wide settings to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.require_admin_for_system_settings is defined %}

Requirement to authenticate as an admin to change system-wide settings is reset to default (enabled):
  cmd.run:
    - name: |
        security authorizationdb read system.preferences > /tmp/system.preferences.plist && \
        /usr/libexec/PlistBuddy -c "Set :shared false" /tmp/system.preferences.plist && \
        security authorizationdb write system.preferences < /tmp/system.preferences.plist
    - unless:
      - |
          security authorizationdb read system.preferences 2> /dev/null | \
          grep -A1 shared | grep -E '(true|false)' | grep 'false'
    - require:
      - System Preferences is not running
{%- endif %}
