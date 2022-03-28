{#-
    Customizes timezone.

    Values:
        - string

    Example:

    .. code-block:: yaml

        timezone: Europe/Paris
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

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
