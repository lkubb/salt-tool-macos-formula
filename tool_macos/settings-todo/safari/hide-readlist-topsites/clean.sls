# vim: ft=sls

Reading List and Top Sites are shown in Safari:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ProxiesInBookmarksBar
    - value: '("Top Sites","Reading List")'
    - vtype: string
    - user: {{ user.name }}
