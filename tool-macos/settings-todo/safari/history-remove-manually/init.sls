Safari history is not cleared automatically:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: HistoryAgeInDaysLimit
    - value: 365000
    - vtype: int
    - user: {{ user.name }}
