{#-
    Customizes timezone.

    Values: string
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.localization is defined and macos.localization.timezone is defined %}

Time zone is managed:
  cmd.run:
    - name: /usr/sbin/systemsetup -settimezone "{{ macos.localization.timezone }}"
    - runas: root
    - require:
        - System Preferences is not running
    - watch_in:
        - ControlCenter was reloaded
    - unless:
        - 'test "$(/usr/sbin/systemsetup -gettimezone)" = "Time Zone: {{ macos.localization.timezone }}"'
{%- endif %}
