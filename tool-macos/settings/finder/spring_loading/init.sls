{#-
    Customizes Finder spring loading behavior (open folder on drag).

    Values:
        - dict

            * enabled: bool (default: true)
            * delay: float (default: 0.5)

    Example:

    .. code-block:: yaml

        spring_loading:
          enabled: true
          delay: 0.1
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.spring_loading', 'defined') %}

Finder spring loading behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - names:
{%- if user.macos.finder.spring_loading.enabled is defined %}
        - com.apple.springing.enabled: # in NSGlobalDomain
            - value: {{ user.macos.finder.spring_loading.enabled | to_bool }}
            - vtype: bool
{%- endif %}
{%- if user.macos.finder.spring_loading.delay is defined %}
        - com.apple.springing.delay: # in NSGlobalDomain
            - value: {{ user.macos.finder.spring_loading.delay | float }}
            - vtype: float
{%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
