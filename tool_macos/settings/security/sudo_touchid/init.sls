# vim: ft=sls

{#-
    Customizes availability of Touch ID and pam_reattach for sudo authentication.

    .. note::

        Since ``/etc/pam.d/sudo`` is reset after a system upgrade, you will
        need to reapply this state occasionally.

    .. hint::

        pam_reattach might be needed for Touch ID authentication inside
        tmux sessions and iTerm saved sessions to work.

    Values:
        - bool [default: false]
        - or dict:

          * enabled: bool [default: false]
          * pam_reattach: bool [default:false]

    References;
        * https://derflounder.wordpress.com/2017/11/17/enabling-touch-id-authorization-for-sudo-on-macos-high-sierra/
        * https://akrabat.com/add-touchid-authentication-to-sudo/
        * https://github.com/fabianishere/pam_reattach
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- if macos.security is defined and macos.security.sudo_touchid is defined %}
{%-   set m = macos.security.sudo_touchid %}
{%-   if m is mapping %}
{%-     set enabled, reattach = (m.get('enabled', False), m.get('pam_reattach', False)) %}
{%-   else %}
{%-     set enabled, reattach = (m | to_bool, False) %}
{%-   endif %}
{%-   set libpam_pre = macos.lookup.brew_prefix ~ '/lib/pam/'
                    if macos.lookup.brew_prefix is not sameas '/usr/local' else '' %}

{%-   if reattach %}

pam_reattach is installed:
  pkg.installed:
    - name: pam-reattach
{%-   endif %}

Availability of Touch ID and pam_reattach for sudo authentication is managed:
  file.blockreplace:
    - name: /etc/pam.d/sudo
    - marker_start: '#-- managed by tool-macos.settings.security.sudo_touchid --'
    - content: |
{%- if reattach %}
        auth       optional       {{ libpam_pre }}pam_reattach.so
{%- endif %}
{%- if enabled %}
        auth       sufficient     pam_tid.so
{%- endif %}
{%- if not enabled and not reattach %}
        # nothing to see here
{%- endif %}
    - insert_after_match: 'sufficient'
{%-   if reattach %}
    - require:
        - pam_reattach is installed
{%-   endif %}
{%- endif %}
