{#-
    Customizes state of sending analytics and crash reports.

    Values:
        - string

          * none
          * apple
          * third_party
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.privacy is defined and macos.privacy.crashreporter_allow is defined %}

Authorization to send analytics is managed:
  macosdefaults.write:
    - domain: /Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist
    - names:
        - AutoSubmit:
            - value: {{ macos.privacy.crashreporter_allow in ['apple', 'third_party'] }}
        - ThirdPartyDataSubmit:
            - value: {{ 'third_party' == macos.privacy.crashreporter_allow }}
    - vtype: bool
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded # there is probably more
{%- endif %}
