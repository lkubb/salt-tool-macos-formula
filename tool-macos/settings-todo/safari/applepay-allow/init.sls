Safari allows websites to check if Apple Pay is set up:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: com.apple.Safari.ContentPageGroupIdentifier.WebKit2ApplePayCapabilityDisclosureAllowed
    - value: True
    - vtype: bool
    - user: {{ user.name }}

# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
