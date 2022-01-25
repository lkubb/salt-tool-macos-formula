{#-
    Resets swipe fullscreen apps touch gesture activation status to default (three-finger).
    This might reset more gestures.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - ..multi_helper.three.clean
  - ..multi_helper.four_horizontal.clean
