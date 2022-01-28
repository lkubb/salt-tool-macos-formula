{#-
    Customizes Finder behavior when a new volume/disk is mounted.

    Values:
        - list [default: all]

            * ro
            * rw
            * disk

    Example:

    .. code-block:: yaml

        new_window_on_mount: [] # never open a new window
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.new_window_on_mount', 'defined') %}

Finder behavior when a new volume is mounted is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.frameworks.diskimages
    - names:
  {%- for type in ['ro', 'rw'] %}
      - auto-open-{{ type }}-root:
          - value: {{ type in user.macos.finder.new_window_on_mount }}
  {%- endfor %}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded

Finder behavior when a new disk is mounted is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: OpenWindowForNewRemovableDisk
    - value: {{ 'disk' in user.macos.finder.new_window_on_mount }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
