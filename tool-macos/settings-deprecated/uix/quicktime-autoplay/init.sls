# seems like no longer working in 10.12 https://github.com/joeyhoer/starter/blob/master/apps/quicktime.sh
Quicktime automatically starts videos on opening:
  macdefaults.write:
    - domain: com.apple.QuickTimePlayerX
    - name: MGPlayMovieOnOpen
    - value: True
    - vtype: bool
    - user: {{ user.name }}
