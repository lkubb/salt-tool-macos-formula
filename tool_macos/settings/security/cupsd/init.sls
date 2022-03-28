{#-
    Customizes activation of cupsd.

    .. hint::

        Webinterface can be found at http://127.0.0.1:631 if enabled.

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.cupsd is defined %}
  {%- set m = macos.security.cupsd %}

Activation of cupsd is managed:
  cmd.run:
    - name: /bin/launchctl {{ 'un' if not m }}load -w /System/Library/LaunchDaemons/org.cups.cupsd.plist
    - runas: root
    - {{ 'unless' if m else 'onlyif' }}:
        - /bin/launchctl list | grep 'org.cups.cupsd'
    - require:
      - System Preferences is not running
{%- endif %}
