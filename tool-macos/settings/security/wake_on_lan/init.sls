{#-
    Manages state of Wake-on-LAN. This setting could be managed in macos.power
    settings as well.

    .. hint::

        Furthermore, this can be set with /usr/sbin/systemsetup setwakeonnetworkaccess

    Values:
        - bool [default: on ac true, on battery false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- if macos.security is defined and macos.security.wake_on_lan is defined %}
  {#- This wall of ifs tries to protect from misconfiguration of this formula.
  -#}
  {%- set womp_managed_and_conflicts = None %}
  {%- if macos.power is defined %}
    {%- for scope, settings in macos.power %}
      {%- if 'womp' in settings.keys() | map('lower') %}
        {%- if str(int(macos.security.wake_on_lan)) == str(int(settings.get('womp'))) %}
          {#- force lowercase womp to be sure #}
          {%- set womp_managed_and_conflicts = False %}
        {%- else %}
          {%- set womp_managed_and_conflicts = True %}
        {%- endif %}
      {%- endif %}
    {%- endfor %}
  {%- endif %}

  {%- if womp_managed_and_conflicts is not sameas None %}
Wake-on-LAN is managed in macos.power and checked:
  test.{{ 'fail_without_changes' if womp_managed_and_conflicts else 'nop' }}:
    - name: {{  'You specified womp in macos.power settings, but the value' ~
                ' is different than what is set for macos.security.wake_on_lan.' if womp_managed_and_conflicts
              else 'womp is managed, but not in conflict.' }}
  {%- endif %}

Wake-on-LAN state is managed:
  pmset.set:
    - name: womp
    - value: {{ macos.security.wake_on_lan | int }}
  {%- if womp_managed_and_conflicts is not sameas None %}
    - require:
      - Wake-on-LAN is managed in macos.power and checked
  {%- endif %}
{%- endif %}
