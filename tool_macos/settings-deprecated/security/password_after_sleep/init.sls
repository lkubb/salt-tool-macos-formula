{#-
    Customizes requirement of password after entering sleep/screensaver.

    You might need to reboot to apply.

    This was moved from the specified plist to MobileKeyBag in 10.13.
    (https://github.com/mathiasbynens/dotfiles/issues/809)
    (https://blog.kolide.com/screensaver-security-on-macos-10-13-is-broken-a385726e2ae2)
    (https://blog.kolide.com/checking-macos-screenlock-remotely-62ab056274f0)

    It is still manageable with a configuration profile.
    (https://gist.github.com/mcw0933/21b8a9e292e83c69931f5de0d2ae1883)

    Values:
      require: bool [default: true]
      delay: int [in seconds, default: 0]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.security', 'defined') | selectattr('macos.security.password_after_sleep', 'defined') %}

Requirement of password after entering sleep is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.screensaver
    - names:
  {%- if user.macos.security.password_after_sleep.require is defined %}
        - askForPassword:
            - value: {{ user.macos.security.password_after_sleep.require | to_bool }}
            - vtype: bool
  {%- endif %}
  {%- if user.macos.security.password_after_sleep.delay is defined %}
        - askForPasswordDelay:
            - value: {{ user.macos.security.password_after_sleep.delay | int }}
            - vtype: int
    {#- warn if delay is managed, but not the requirement itself -#}
    {%- if user.macos.security.password_after_sleep.require is not defined %}
       {%- do salt['log.warning']((
            "A custom delay for password requirement after sleep was set for user {}, " ~
            "but the requirement of passwords itself is not managed.").format(user.name)) %}
    {%- endif %}
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
