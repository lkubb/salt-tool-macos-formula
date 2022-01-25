@TODO
```
# Test size
# 1: Small
# 7: Large
defaults write com.apple.iChat TextSize -int 2

# Anumate buddy pictures
defaults write com.apple.iChat AnimateBuddyPictures -bool false

# Play sound effects
defaults write com.apple.messageshelper.AlertsController PlaySoundsKey -bool false

# Notify me when my name is mentioned
defaults write com.apple.messageshelper.AlertsController SOAlertsAddressMeKey -bool false

# Notify me about messages form unknown contacts
defaults write com.apple.messageshelper.AlertsController NotifyAboutKnockKnockKey -bool false

# Show all buddy pictures in conversations
defaults write com.apple.iChat ShowAllBuddyPictures -bool false
```
https://github.com/joeyhoer/starter/blob/master/apps/messages.sh
