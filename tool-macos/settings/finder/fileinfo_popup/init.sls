{#-
    Customizes file info popup expanded panes.

    Values:
      comments: bool [default: false]
      metadata: bool [default: true]
      name: bool [default: false]
      openwith: bool [default: true]
      privileges: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.fileinfo_popup', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

File info popup expanded panes are managed for user {{ user.name }}:
  macosdefaults.update:
    - domain: com.apple.finder
    - name: FXInfoPanesExpanded
    - value: {{ user_settings | json }}
    - skeleton:
        FXInfoPanesExpanded:
          Comments: false
          MetaData: true
          Name: false
          OpenWith: true
          Privileges: true
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded # unsure
{%- endfor %}
