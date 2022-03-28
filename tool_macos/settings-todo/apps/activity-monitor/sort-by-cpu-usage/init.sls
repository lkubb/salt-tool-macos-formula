In Activity Monitor, sort by CPU usage:
  macdefaults.write:
    - domain: com.apple.ActivityMonitor
    - name: SortColumn
    - value: CPUUsage
    - vtype: string
    - user: {{ user.name }}

In Activity Monitor, sort descending:
  macdefaults.write:
    - domain: com.apple.ActivityMonitor
    - name: SortDirection
    - value: 0
    - vtype: int
    - user: {{ user.name }}
