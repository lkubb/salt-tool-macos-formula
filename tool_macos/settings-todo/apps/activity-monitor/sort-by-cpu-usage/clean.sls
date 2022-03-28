Reset Activity Monitor sort column:
  macdefaults.absent:
    - domain: com.apple.ActivityMonitor
    - name: SortColumn
    - user: {{ user.name }}

Reset Activity Monitor sort direction:
  macdefaults.absent:
    - domain: com.apple.ActivityMonitor
    - name: SortDirection
    - user: {{ user.name }}
