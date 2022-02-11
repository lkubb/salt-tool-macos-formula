{#-
    Customizes activation state of services.

    .. note::

        This does not affect which services are running at the time of application.

    .. hint::

        This manages both global and user-specific service states.

    Values:
        - dict

            * wanted: list [of enabled services]
            * unwanted: list [of disabled services]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require


# ----------------- global ----------------------------------------

{%- set global_services = macos.get('services', {}) %}

{%- for enabled in global_services.get('wanted', []) %}

Global service '{{ enabled }}' is enabled:
  service.enabled:
      - name: {{ enabled }}
{%- endfor %}

{%- for disabled in global_services.get('unwanted', []) %}

Global service '{{ enabled }}' is disabled:
  service.disabled:
      - name: {{ disabled }}
{%- endfor %}


# ----------------- user-specific ---------------------------------

{%- for user in macos.users | selectattr('macos.services', 'defined') %}

  {%- for enabled in user.macos.services.get('wanted', []) %}

Service '{{ enabled }}' is enabled for user '{{ user.name }}':
  service.enabled:
    - name: {{ enabled }}
    - runas: {{ user.name }}
  {%- endfor %}

  {%- for disabled in user.macos.services.get('unwanted', []) %}

Service '{{ disabled }}' is disabled for user '{{ user.name }}':
  service.disabled:
    - name: {{ disabled }}
    - runas: {{ user.name }}
  {%- endfor %}
{%- endfor %}
