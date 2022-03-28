# this has been dysfunctional from El Capitan onwards
# see eg https://github.com/rodionovd/dotfiles/blob/master/osx.sh
Quicklook allows text selection:
  macdefaults.write:
    - domain: com.apple.LaunchServices
    - name: QLEnableTextSelection
    - value: True
    - vtype: bool
    - user: {{ user.name }}
