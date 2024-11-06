# vim: ft=sls

{#-
    Resets Gatekeeper activation status to default (enabled).

    Values: bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.gatekeeper is defined %}
  {%- set m = macos.security.gatekeeper %}

Gatekeeper activation status is reset to default (enabled):
  cmd.run:
    - name: /usr/sbin/spctl --master-enable
    - runas: root
    - unless:
        - /usr/sbin/spctl --status | grep 'assessments enabled'
    - require:
      - System Preferences is not running
{%- endif %}
