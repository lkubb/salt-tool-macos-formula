# vim: ft=sls

{#-
    Customizes Gatekeeper activation status.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.gatekeeper is defined %}
{%-   set m = macos.security.gatekeeper %}

Gatekeeper activation status is managed:
  cmd.run:
    - name: /usr/sbin/spctl --master-{{ "enable" if m else "disable" }}
    - runas: root
    - unless:
        - /usr/sbin/spctl --status | grep 'assessments {{ "enabled" if m else "disabled" }}'
    - require:
      - System Preferences is not running
{%- endif %}
