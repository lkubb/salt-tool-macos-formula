{#-
    Customizes state of AirDrop.

    Mind that the setting is called "Disable...", so the pillar value is inverted
    for consistency's sake.

    Also mind that many security settings should be set via policy (configuration profile).

    Values: bool [default: true]

    References:
      https://github.com/usnistgov/macos_security/blob/main/rules/os/os_airdrop_disable.yaml
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.security', 'defined') | selectattr('macos.security.airdrop', 'defined') %}

AirDrop state is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.NetworkBrowser
    - name: DisableAirDrop
    - value: {{ False == user.macos.security.airdrop | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
