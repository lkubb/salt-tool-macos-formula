# vim: ft=sls

{#-
    Customizes whether Feedback Assistant automatically gathers
    large files when submitting a report.

    Values:
        - bool [default: true]

    References:
        * https://macos-defaults.com/feedback-assistant/autogather.html
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.feedback_assistant_autogather", "defined") %}

Feedback Assistant autogather large files behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.appleseed.FeedbackAssistant
    - name: Autogather
    - value: {{ user.macos.behavior.feedback_assistant_autogather | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
