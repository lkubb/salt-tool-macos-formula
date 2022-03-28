{#-
    Customizes MacOS window resize time.

    .. note::

        Might take a reboot to apply.

    Values:
        - float [default: 0.5?]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.window_resize_time', 'defined') %}

MacOS window resize time is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSWindowResizeTime # in NSGlobalDomain
    - value: {{ user.macos.animations.window_resize_time | float }}
    - vtype: real
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
