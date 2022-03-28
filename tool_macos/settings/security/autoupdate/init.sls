{#-
    Customizes automatic update settings.

    .. hint::

        This works without a configuration profile and is how System Preferences
        writes the settings. The references are for MDM.

    Values:
        - dict

            * check: bool [default: true]
            * download: bool [default: true]
            * install_app: bool [default: true]
            * install_config: bool [default: true]
            * install_critical: bool [default: true]
            * install_system: bool [default: true]
            * schedule: int [every i day(s), default: 1]

    .. note::

        * check > download > install (requisites)
        * install_config and install_critical are combined in System Preferences.

    References:
        * https://developer.apple.com/documentation/devicemanagement/softwareupdate
        * https://derflounder.wordpress.com/2019/10/10/enable-automatic-macos-and-app-store-updates-on-macos-catalina-with-a-profile/
-#}

{#- com.apple.appstore should have
        DisableSoftwareUpdateNotifications
        restrict-store-disable-app-adoption
        restrict-store-mdm-install-softwareupdate-only
        restrict-store-require-admin-to-install
        restrict-store-softwareupdate-only
#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.autoupdate is defined %}
  {%- from tpldir ~ '/map.jinja' import system_settings, appstore_setting with context %}

Automatic system update settings are managed:
  macosdefaults.write:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/com.apple.SoftwareUpdate
    - names:
  {%- for setting, value in system_settings.items() if setting != 'ScheduleFrequency' %}
        - {{ setting }}:
            - value: {{ value | to_bool }}
            - vtype: bool
  {%- endfor %}
  {%- if system_settings.get('ScheduleFrequency') %}
        - ScheduleFrequency:
            - value: {{ system_settings.ScheduleFrequency | int }}
            - vtype: int
  {%- endif %}
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Automatic App Store update settings are managed:
  macosdefaults.write:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    # (finds another file there with PurchasesInflight)
    - domain: /Library/Preferences/com.apple.commerce.plist
    - name: AutoUpdate
    - value: {{ appstore_setting | to_bool }}
    - vtype: bool
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}

