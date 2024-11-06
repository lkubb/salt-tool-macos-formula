# vim: ft=sls

Webkit Nightly startpage is enabled:
  macdefaults.write:
    - domain: org.webkit.nightly.WebKit
    - name: StartPageDisabled
    - value: False
    - vtype: bool
    - user: {{ user.name }}

# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
