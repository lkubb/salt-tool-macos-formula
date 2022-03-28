{#-
    Customizes swipe fullscreen apps touch gesture activation status.

    Values:
        - string [default: three]

            * three
            * four

        - or false
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - ..multi_helper.three
  - ..multi_helper.four_horizontal
