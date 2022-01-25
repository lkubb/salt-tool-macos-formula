{#-
    Resets the requirement to authenticate as an admin to change
    system-wide settings to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.require_admin_for_system_settings is defined %}

Requirement to authenticate as an admin to change system-wide settings is reset to default (enabled):
  cmd.run:
    - name: |
        security authorizationdb read system.preferences > /tmp/system.preferences.plist && \
        /usr/libexec/PlistBuddy -c "Set :shared false" /tmp/system.preferences.plist && \
        security authorizationdb write system.preferences < /tmp/system.preferences.plist
    - unless:
      - |
          test -n "$(security authorizationdb read system.preferences 2> /dev/null | \
          grep -A1 shared | grep -E '(true|false)' | grep 'false')" ] && exit 0 || exit 1
    - require:
      - System Preferences is not running
{%- endif %}
