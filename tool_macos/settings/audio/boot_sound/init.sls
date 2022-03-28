{#-
    Customizes boot sound (chime) behavior.

    Values:
        - bool [default: false since 2016 models]

    .. hint::

        Earlier, this could be set with `nvram SystemAudioVolume=" " / =%80.`

    References:
        * https://apple.stackexchange.com/questions/168092/disable-os-x-startup-sound
        * https://apple.stackexchange.com/questions/409521/how-to-stop-startup-chime-on-boot-up
        * https://git.herrbischoff.com/awesome-macos-command-line/about/
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- if macos.audio is defined and macos.audio.boot_sound is defined %}
  {%- set val = '00' if macos.audio.boot_sound else '01'  %}
Boot sound (chime) is managed:
  cmd.run:
    - name: /usr/sbin/nvram StartupMute=%{{ val }}
    - runas: root
    - unless:
        - /usr/sbin/nvram StartupMute | grep '%{{ val }}'
{%- endif %}
