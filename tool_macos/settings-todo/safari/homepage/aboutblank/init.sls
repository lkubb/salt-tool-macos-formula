Safari homepage is set to about:blank:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: HomePage
    - value: about:blank
    - vtype: string
    - user: {{ user.name }}
