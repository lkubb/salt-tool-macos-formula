{#-
    Deletes mail account configuration (somewhat). Since profiles cannot be managed
    silently on a Mac that is not MDM-enrolled, this resets the profile to empty.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.accounts', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

Mail accounts removed for user {{ user.name }}:
  macprofile.installed:
    - name: salt.tool.macos-config.mail
    - description: Mail account configuration managed by Salt state tool-macos.settings.mail.accounts
    - organization: salt.tool
    - removaldisallowed: False
    - ptype: com.apple.mail.managed
    - content: []
{%- endfor %}
