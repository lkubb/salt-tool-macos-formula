Hide the line marks in Terminal.app (| in front of lines, functionality is intact):
  macdefaults.write:
    - domain: com.apple.terminal
    - name: ShowLineMarks
    - value: 0
    - vtype: int
    - user: {{ user.name }}
