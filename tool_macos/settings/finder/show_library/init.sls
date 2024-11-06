# vim: ft=sls

{#-
    Customizes display status of ~/Library folder.

    Values:
        - bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

# there is xattr.exists state in saltstack, but I was
# unsure if there was one for chflags
{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.show_library", "defined") %}

Display status of ~/Library is managed for user {{ user.name }}:
  cmd.run:
    - name: |
        if [ -n '{{ "yes" if user.macos.finder.show_library }}' ]; then
          chflags nohidden {{ user.home }}/Library
          if xattr -l {{ user.home }}/Library | grep com.apple.FinderInfo; then
            xattr -d com.apple.FinderInfo {{ user.home }}/Library
          else
            exit 0
          fi
        else
          chflags hidden {{ user.home }}/Library
          xattr -wx com.apple.FinderInfo \
            '0000000000000000400000000000000000000000000000000000000000000000' \
            {{ user.home }}/Library
        fi
    - runas: {{ user.name }}
{%- endfor %}

# $ xattr -lx ~/Library
# com.apple.FinderInfo:
# 00000000  00 00 00 00 00 00 00 00 40 00 00 00 00 00 00 00  |........@.......|
# 00000010  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  |................|
# 00000020
