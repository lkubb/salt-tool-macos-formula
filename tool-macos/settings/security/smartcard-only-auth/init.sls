{#-
    Customizes state of forced smart card authentication.

    .. note::

        You might need to reboot to apply changed settings. macOS 10.13.2 or later.

    Values:
        - bool [default: false]

    References;
        * https://support.apple.com/guide/deployment/configure-macos-smart-cardonly-authentication-depfce8de48b/1/web/1.0
        * https://support.apple.com/HT208372
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.smartcard_forced_auth is defined %}

Automatic detection of captive portals is managed:
  macosdefaults.write:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/com.apple.security.smartcard
    - name: enforceSmartCard
    - value: {{ macos.security.smartcard_forced_auth | to_bool }}
    - vtype: bool
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
