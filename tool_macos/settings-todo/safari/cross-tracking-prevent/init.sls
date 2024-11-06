# vim: ft=sls

Safari prevents tracking over different sites while limiting usability breakage:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - BlockStoragePolicy:
        - value: 2
      - WebKitStorageBlockingPolicy:
        - value: 1
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2StorageBlockingPolicy:
        - value: 1
    - vtype: int
    - user: {{ user.name }}

# Cookies and website data:
# 0,2: Alwasy block
# 3,1: Allow from current website only
# 2,1: Allow from websites I visit
# 1,0: Alwasy allow
# defaults write com.apple.Safari BlockStoragePolicy -int 2
# defaults write com.apple.Safari WebKitStorageBlockingPolicy -int 1
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2StorageBlockingPolicy -int 1
# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
