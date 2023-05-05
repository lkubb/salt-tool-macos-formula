{#-
    Installs custom CA root certificates.

    Requires ``x509_v2`` modules.

    .. note::

        This requires user interaction.

    Values:
        - list [default: []]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- if macos.security is defined and macos.security.ca_root is defined %}

Custom CA root certificates are installed:
  macprofile.installed:
    - name: salt.tool.macos-config.ca_root
    - displayname: Custom CA root certificates
    - description: Custom CA root certificates managed by Salt state tool-macos.settings.security.ca_root
    - organization: salt.tool
    - removaldisallowed: False
    - ptype: com.apple.security.root
    - scope: System
    - content:
{%-   for crt in macos.security.ca_root %}
      - PayloadType: com.apple.security.pem
        PayloadContent: {{ "base64:" ~ salt["x509.encode_certificate"](crt, "der") | json }}
  {%- endfor %}
{%- endif %}
