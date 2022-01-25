# at least on Monterey, this does not work.
# sorting settings are probably saved in mail.savedState/

Mails are sorted in threads:
  macosdefaults.set:
    - domain: com.apple.mail
    - name: DraftsViewerAttributes:DisplayInThreadedMode
    - value: 'YES'
    - vtype: string
    - user: {{ user.name }}

Mails are sorted descending:
  macosdefaults.set:
    - domain: com.apple.mail
    - name: DraftsViewerAttributes:SortedDescending
    - value: 'YES'
    - vtype: string
    - user: {{ user.name }}

Mails are sorted by received date:
  macosdefaults.set:
    - domain: com.apple.mail
    - name: DraftsViewerAttributes:SortOrder
    - value: received-date
    - vtype: string
    - user: {{ user.name }}
