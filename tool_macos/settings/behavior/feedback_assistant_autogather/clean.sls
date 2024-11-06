# vim: ft=sls

{#-
    Resets whether Feedback Assistant automatically gathers
    large files when submitting a report to default (true).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.feedback_assistant_autogather", "defined") %}

Feedback Assistant autogather large files behavior is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.appleseed.FeedbackAssistant
    - name: Autogather
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
