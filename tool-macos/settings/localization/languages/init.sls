{#-
    Customizes available system languages.

    Some more settings that could be set:
      Week begins on Monday/Tuesday etc: AppleFirstWeekday -dict {gregorian: -int 2/3} etc
      Locale: AppleLocale, eg: en_US@currency=USD@calendar=buddhist
      Country: Country -string "US"
    Values: str
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.localization', 'defined') | selectattr('macos.localization.languages', 'defined') %}

Available system languages are managed for user {{ user.name }}:
  macosdefaults.set:
    - name: AppleLanguages # in NSGlobalDomain
    - value: {{ user.macos.localization.languages | json }}
    - vtype: array
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
