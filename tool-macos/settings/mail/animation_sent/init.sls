{#-
    Customizes activation status of sent animation.

    Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Mind that the actual setting is called "Disable...", so the
    pillar value is inverted for consistency.

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.animation_sent', 'defined') %}

Activation status of sent animation in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: DisableSendAnimations
    - value: {{ False == user.macos.mail.animation_sent | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
