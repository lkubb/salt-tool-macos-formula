# vim: ft=sls

Safari's Developer menu is enabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: IncludeDevelopMenu
    - value: True
    - vtype: bool
    - user: {{ user.name }}

# There's also Web Inspector, which e.g. allows inspecting the inspector =D. This works/worked for all WebKit applications.
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# # Add a context menu item for showing the Web Inspector in web views
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable
# defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
# defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
# defaults write -g WebKitDeveloperExtras -bool true
