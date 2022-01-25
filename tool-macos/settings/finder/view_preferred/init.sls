{#-
    Customizes preferred Finder view settings.

    Values:
      groupby: str  # none, name, app, kind, last_opened, added, modified, created, size, tags
      style: str    # icon / list / gallery / column [coverflow deprecated?]

    Those values are set when selecting from View menu.
    They are different from [FK_][Standard,Default]ViewSettings.

    Note: This would need to delete per-folder settings to apply to all directories:
          # find $HOME -name ".DS_Store" --delete

    References:
      https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{#- by default, grouping is disabled. there is no FXPreferredSortBy though -#}
{%- set group_opts = {
  'none': 'None',
  'name': 'Name',
  'app': 'Application',
  'kind': 'Kind',
  'last_opened': 'Date Last Opened',
  'added': 'Date Added',
  'modified': 'Date Modified',
  'created': 'Date Created',
  'size': 'Size',
  'tags': 'Tags'
  } -%}

{#- coverflow was deprecated, short value was Flwv-#}
{%- set style_opts = {
  'icon': 'icnv',
  'list': 'Nlsv',
  'column': 'clmv',
  'gallery': 'glyv'
  } -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.view_preferred', 'defined') %}

Desktop icon settings are customized for user {{ user.name }}:
  macosdefaults.update:
    - domain: com.apple.finder
    - names:
  {%- if user.macos.finder.view_preferred.groupby is defined %}
        - FXPreferredGroupBy:
            - value: {{ group_opts.get(user.macos.finder.view_preferred.groupby, 'none') }}
  {%- endif %}
  {%- if user.macos.finder.view_preferred.style is defined %}
        - FXPreferredViewStyle:
            - value: {{ style_opts.get(user.macos.finder.view_preferred.style, 'icon')}}
  {%- endif %}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
