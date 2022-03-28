Safari saves downloads to custom path:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: DownloadsPath
    - value: {{ user.macos.safari.download_path }}
    - vtype: bool
    - user: {{ user.name }}
