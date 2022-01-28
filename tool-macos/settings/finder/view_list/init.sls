{#-
    Customizes default Finder List View settings for all folders.

    Values:
        - dict

            * calc_all_sizes: bool [default: false]
            * icon_size: float [default: 16]
            * preview: bool [default: true]
            * sort_col: string [default: name]
            * text_size: float [default: 13]
            * relative_dates: bool [default: true]

    .. warning::

        This was not tested at all. Proceed with care.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

# @TODO: specify custom column layout
{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.view_list', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

Default List View settings are customized for user {{ user.name }}:
  macosdefaults.update:
    - domain: com.apple.finder
    - names:
        - StandardViewSettings:ListViewSettings:
            - skeleton:
                StandardViewSettings:
                  ListViewSettings:
                    calculateAllSizes: false
                    columns:
                      comments:
                        ascending: true
                        index: 7 # int
                        visible: false
                        width: 300 # int
                      dateCreated:
                        ascending: false
                        index: 2 # int
                        visible: false
                        width: 181 # int
                      dateLastOpened:
                        ascending: false
                        index: 8 # int
                        visible: false
                        width: 200 # int
                      dateModified:
                        ascending: false
                        index: 1 # int
                        visible: true
                        width: 181 # int
                      kind:
                        ascending: true
                        index: 4 # int
                        visible: true
                        width: 115 # int
                      label:
                        ascending: true
                        index: 5 # int
                        visible: false
                        width: 100 # int
                      name:
                        ascending: true
                        index: 0 # int
                        visible: true
                        width: 300 # int
                      size:
                        ascending: false
                        index: 3 # int
                        visible: true
                        width: 97 # int
                      version:
                        ascending: true
                        index: 6 # int
                        visible: false
                        width: 75 # int
                    iconSize: 16 # real
                    showIconPreview: true
                    sortColumn: name
                    textSize: 13 # real
                    useRelativeDates: true
                    viewOptionsVersion: 1 # int

        - StandardViewSettings:ExtendedListViewSettingsV2:
            - skeleton:
                StandardViewSettings:
                  ExtendedListViewSettingsV2:
                    calculateAllSizes: false
                    columns:
                      - ascending: true
                        identifier: name
                        visible: true
                        width: 300 # int
                      - ascending: false
                        identifier: ubiquity
                        visible: false
                        width: 35 # int
                      - ascending: false
                        identifier: dateModified
                        visible: true
                        width: 181 # int
                      - ascending: false
                        identifier: dateCreated
                        visible: false
                        width: 181 # int
                      - ascending: false
                        identifier: size
                        visible: true
                        width: 97 # int
                      - ascending: true
                        identifier: kind
                        visible: true
                        width: 115 # int
                      - ascending: true
                        identifier: label
                        visible: false
                        width: 100 # int
                      - ascending: true
                        identifier: version
                        visible: false
                        width: 75 # int
                      - ascending: true
                        identifier: comments
                        visible: false
                        width: 300 # int
                      - ascending: false
                        identifier: dateLastOpened
                        visible: false
                        width: 200 # int
                      - ascending: false
                        identifier: shareOwner
                        visible: false
                        width: 200 # int
                      - ascending: false
                        identifier: shareLastEditor
                        visible: false
                        width: 200 # int
                      - ascending: false
                        identifier: dateAdded
                        visible: false
                        width: 181 # int
                      - ascending: false
                        identifier: invitationStatus
                        visible: false
                        width: 210 # int
                    iconSize: 16.0 # real
                    showIconPreview: true
                    sortColumn: name
                    textSize: 13.0 # real
                    useRelativeDates: true
                    viewOptionsVersion: 1 # int
    - value: {{ user_settings }}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
