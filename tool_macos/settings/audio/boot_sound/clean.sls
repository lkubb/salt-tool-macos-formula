{#-
    Resets boot sound (chime) behavior [default: disabled since 2016 models].

    Earlier, this could be set with SystemAudioVolume.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

Boot sound is reset to default (disabled):
  cmd.run:
    - name: /usr/sbin/nvram -d StartupMute
    - runas: root
