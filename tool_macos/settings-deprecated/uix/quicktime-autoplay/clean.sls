# vim: ft=sls

Quicktime does not automatically start videos on opening:
  macdefaults.absent:
    - domain: com.apple.QuickTimePlayerX
    - name: MGPlayMovieOnOpen
    - user: {{ user.name }}
