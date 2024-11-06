# vim: ft=sls

Safari saves downloads to default path:
  macdefaults.absent:
    - domain: com.apple.Safari
    - name: DownloadsPath
    - user: {{ user.name }}
