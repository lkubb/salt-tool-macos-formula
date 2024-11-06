# vim: ft=sls

{#-
    Removes custom CA root certificates.

    .. note::

        This requires user interaction.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- if macos.security is defined and macos.security.ca_root is defined %}

Custom CA root certificates are removed:
  macprofile.absent:
    - name: salt.tool.macos-config.ca_root
{%- endif %}
