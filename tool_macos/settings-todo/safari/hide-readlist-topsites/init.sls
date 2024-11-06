# vim: ft=sls

Reading List and Top Sites are hidden in Safari:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ProxiesInBookmarksBar
    - value: '()'
    - vtype: string
    - user: {{ user.name }}
