Webkit Nightly startpage is disabled:
  macdefaults.write:
    - domain: org.webkit.nightly.WebKit
    - name: StartPageDisabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}

# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
