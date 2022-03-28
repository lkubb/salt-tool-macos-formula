# Security on MacOS
https://github.com/alichtman/stronghold
https://github.com/usnistgov/macos_security

## SIP
```
$ csrutil status
System Integrity Protection status: enabled.
```

## Managing Privacy/Security Settings
```
###############################################################################
# Privacy
#
# Privacy should be handled within each application's configuration using
# the `tccutil` package installed via Homebrew.
# Note: SIP must be disabled to modify the database.
#
# The below outlines an altenrative solution for configuring privacy.
###############################################################################

# Databases located at:
#   /Library/Application\ Support/com.apple.TCC/TCC.db
#   ~/Library/Application\ Support/com.apple.TCC/TCC.db

# All           : kTCCServiceAll
# Accessibility : kTCCServiceAccessibility
# Calendar      : kTCCServiceCalendar
# Contacts      : kTCCServiceAddressBook
# Location      : kTCCServiceLocation
# Reminders     : kTCCServiceReminders
# Facebook      : kTCCServiceFacebook
# LinkedIn      : kTCCServiceLinkedIn
# Twitter       : kTCCServiceTwitter
# SinaWeibo     : kTCCServiceSinaWeibo
# Liverpool     : kTCCServiceLiverpool
# Ubiquity      : kTCCServiceUbiquity
# TencentWeibo  : kTCCServiceTencentWeibo

# service | client | client_type | allowed | prompt_count | csreq | policy_id

# Grant access
# sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db \
#   "INSERT INTO access VALUES(${service},${bundle_id},0,1,1,NULL);"

# Reset access
# sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db \
#   "DELETE FROM access WHERE client CLIENT '${bundle_id}';"

# Revoke access
# sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db \
#   "INSERT INTO access VALUES(${service},${bundle_id},0,0,1,NULL);"
```
tccutil only works with SIP disabled though

## References
### Smartcard
* `man SmartCardServices`
* https://support.apple.com/en-gb/HT208372
* https://support.apple.com/en-gb/guide/deployment-reference-macos/apd2969ad2d7/1/web/1.0
* https://gist.github.com/synthetic-intelligence/e07f0422720601f10ef1b2d6fa2afa12https://gist.github.com/synthetic-intelligence/e07f0422720601f10ef1b2d6fa2afa12https://gist.github.com/synthetic-intelligence/e07f0422720601f10ef1b2d6fa2afa12
* https://developers.yubico.com/PIV/Guides/Smart_card-only_authentication_on_macOS.html
