# vim: ft=sls

{#-
    Customizes activation status of loading remote content.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.remote_content", "defined") %}

Activation status of loading remote content in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail-shared
    - name: DisableURLLoading
    {#- Mind that the actual setting is called "Disable...", so the
    pillar value is inverted for consistency. #}
    - value: {{ False == user.macos.mail.remote_content | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
