# vim: ft=sls

Apple Mail does not spell-check automatically:
  macdefaults.write:
    - domain: com.apple.mail
    - name: SpellCheckingBehavior
    - value: NoSpellCheckingEnabled
    - vtype: string
    - user: {{ user.name }}

# Checking Spelling
# Note: NSAllowContinuousSpellChecking must be enabled
# While Typing   : InlineSpellCheckingEnabled
# Before Sending : SpellCheckingOnSendEnabled
# Never          : NoSpellCheckingEnabled
# defaults write com.apple.mail SpellCheckingBehavior -string "InlineSpellCheckingEnabled"
