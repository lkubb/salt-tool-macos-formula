Safari does not automatically save sites for offline reading:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ReadingListSaveArticlesOfflineAutomatically
    - value: False
    - vtype: bool
    - user: {{ user.name }}

# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
