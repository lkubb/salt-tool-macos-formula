# vim: ft=sls

Safari automatically saves sites for offline reading:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ReadingListSaveArticlesOfflineAutomatically
    - value: True
    - vtype: bool
    - user: {{ user.name }}

# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
