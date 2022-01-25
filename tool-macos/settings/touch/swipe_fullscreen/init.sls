{#-
    Customizes swipe fullscreen apps touch gesture activation status.
    Values: three / four / false [default: three]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - ..multi_helper.three
  - ..multi_helper.four_horizontal
