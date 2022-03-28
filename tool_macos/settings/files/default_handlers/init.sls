{#-
    Customizes the default handler for file types and URL schemes.

    Values:
        - dict
            * extensions: dict

                - extension: handler

            * schemes: dict

                - scheme: handler

            * utis: dict

                - uti: handler

    .. note::

        The handler has to be installed at the point where this state
        is run, otherwise it will fail. It can be specified by name,
        bundle ID or absolute file path.

    Example:

    .. code-block:: yaml

        default_handlers:
          extensions:  # extensions will be automatically resolved to all associated UTI
            csv: Sublime Text
            html: Firefox
          schemes:
            http: org.mozilla.Firefox # this will set https as well, user prompt is shown
            ipfs: /Applications/Brave Browser.app
            torrent: Transmission
          utis:
            public.plain-text: TextEdit
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.files', 'defined') | selectattr('macos.files.default_handlers', 'defined') %}

  {%- for extension, handler in user.macos.files.default_handlers.get('extensions', {}).items() %}

Default handler for file extension '{{ extension }}' is managed for user {{ user.name }}:
  dooti.ext:
    - name: {{ extension }}
    - handler: {{ handler }}
    - user: {{ user.name }}
    - watch_in:
      - Finder was reloaded
  {%- endfor %}

  {%- for scheme, handler in user.macos.files.default_handlers.get('schemes', {}).items() %}

Default handler for URL scheme '{{ scheme }}' is managed for user {{ user.name }}:
  dooti.scheme:
    - name: {{ scheme }}
    - handler: {{ handler }}
    - user: {{ user.name }}
    - watch_in:
      - Finder was reloaded
  {%- endfor %}

  {%- for uti, handler in user.macos.files.default_handlers.get('utis', {}).items() %}

Default handler for UTI '{{ uti }}' is managed for user {{ user.name }}:
  dooti.uti:
    - name: {{ uti }}
    - handler: {{ handler }}
    - user: {{ user.name }}
    - watch_in:
      - Finder was reloaded
  {%- endfor %}
{%- endfor %}
