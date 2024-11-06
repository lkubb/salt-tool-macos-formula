Security
========

The following states are found in settings-deprecated.security:

.. contents::
   :local:


ir_receiver
-----------
Customizes Infrared sensor activation status.

This has not been a thing in a long time.

https://en.wikipedia.org/wiki/Apple_Remote#Compatibility

Values: bool [default: true]


password_after_sleep
--------------------
Customizes requirement of password after entering sleep/screensaver.

You might need to reboot to apply.

This was moved from the specified plist to MobileKeyBag in 10.13.
(https://github.com/mathiasbynens/dotfiles/issues/809)
(https://blog.kolide.com/screensaver-security-on-macos-10-13-is-broken-a385726e2ae2)
(https://blog.kolide.com/checking-macos-screenlock-remotely-62ab056274f0)

It is still manageable with a configuration profile.
(https://gist.github.com/mcw0933/21b8a9e292e83c69931f5de0d2ae1883)

Values:
  require: bool [default: true]
  delay: int [in seconds, default: 0]


swap-encryption-disabled
------------------------



