{#-
    Resets state of sending analytics and crash reports to default (enabled?).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.privacy is defined and macos.privacy.crashreporter_allow is defined %}

Authorization to send analytics is reset to default:
  macosdefaults.absent:
    - domain: /Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist
    - names:
        - AutoSubmit
        - ThirdPartyDataSubmit
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded # there is probably more
{%- endif %}
