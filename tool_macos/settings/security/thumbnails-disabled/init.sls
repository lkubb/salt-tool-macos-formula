{#-
@internal
Does not do anything at the moment, serves as a reminder.
I'm not certain this is sensible. Can be set with user-specific
Finder settings though.

References;
  https://github.com/SummitRoute/osxlockdown/blob/master/commands.yaml

@TODO ?

- title: "Disable Previews"
  check_command: |
    defaults read /Library/Preferences/com.apple.finder.plist | grep ShowIconThumbnails | grep 0
  fix_command: |
    /usr/libexec/PlistBuddy -c "Add StandardViewOptions:ColumnViewOptions:ShowIconThumbnails bool NO" "/Library/Preferences/com.apple.finder.plist" && /usr/libexec/PlistBuddy -c "Add StandardViewSettings:ListViewSettings:showIconPreview bool NO" "/Library/Preferences/com.apple.finder.plist" && /usr/libexec/PlistBuddy -c "Add StandardViewSettings:IconViewSettings:showIconPreview bool NO" "/Library/Preferences/com.apple.finder.plist" && /usr/libexec/PlistBuddy -c "Add StandardViewSettings:ExtendedListViewSettings:showIconPreview bool NO" "/Library/Preferences/com.apple.finder.plist" && /usr/libexec/PlistBuddy -c "Add StandardViewOptions:ColumnViewOptions:ShowPreview bool NO" "/Library/Preferences/com.apple.finder.plist" && /usr/libexec/PlistBuddy -c "Add StandardViewSettings:ListViewSettings:showPreview bool NO" "/Library/Preferences/com.apple.finder.plist" && /usr/libexec/PlistBuddy -c "Add StandardViewSettings:IconViewSettings:showPreview bool NO" "/Library/Preferences/com.apple.finder.plist" &&  /usr/libexec/PlistBuddy -c "Add StandardViewSettings:ExtendedListViewSettings:showPreview bool NO" "/Library/Preferences/com.apple.finder.plist"
  comment: "TODO: I'm only checking one item, check all"
  enabled: true

-#}
