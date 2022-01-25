@TODO
# Audible and Visual Bells
/usr/libexec/PlistBuddy                                     \
    -c "Delete :WindowSettings:Basic:Bell"                  \
    -c "Add    :WindowSettings:Basic:Bell       bool false" \
    -c "Delete :WindowSettings:Basic:VisualBell"            \
    -c "Add    :WindowSettings:Basic:VisualBell bool true"  \
    ~/Library/Preferences/com.apple.terminal.plist


# https://github.com/joeyhoer/starter/blob/master/apps/terminal.sh
