Security
========

The following states are found in settings.security:


airdrop_disabled
----------------
Customizes state of AirDrop.

.. note::

    Mind that many security settings should be set via policy (configuration profile).

Values:
    - bool [default: true]

References:
    * https://github.com/usnistgov/macos_security/blob/main/rules/os/os_airdrop_disable.yaml


autologin
---------
Customizes automatic login.

Values:
    - false or string [= username. default: false]


autoupdate
----------
Customizes automatic update settings.

.. hint::

    This works without a configuration profile and is how System Preferences
    writes the settings. The references are for MDM.

Values:
    - dict

        * check: bool [default: true]
        * download: bool [default: true]
        * install_app: bool [default: true]
        * install_config: bool [default: true]
        * install_critical: bool [default: true]
        * install_system: bool [default: true]
        * schedule: int [every i day(s), default: 1]

.. note::

    * check > download > install (requisites)
    * install_config and install_critical are combined in System Preferences.

References:
    * https://developer.apple.com/documentation/devicemanagement/softwareupdate
    * https://derflounder.wordpress.com/2019/10/10/enable-automatic-macos-and-app-store-updates-on-macos-catalina-with-a-profile/


captive_portal_detection
------------------------
Customizes automatic detection of captive portals.

.. note::

    You might need to reboot to apply changed settings.

Values:
    - bool [default: true]


cupsd
-----
Customizes activation of cupsd.

.. hint::

    Webinterface can be found at http://127.0.0.1:631 if enabled.

Values:
    - bool [default: true]


filevault_autologin
-------------------
Customizes automatic login of FileVault authenticated user.

Values: bool [default: true]


filevault_evict_keys_standby
----------------------------
Customizes eviction of FileVault keys on standby. When enabled,
that means you need to re-enter your encryption password during wakeup
from hibernation.

.. note::

    This `might not make a big difference <https://discussions.apple.com/thread/253568420>`_ on current M1 Macs and those with
    T2 security chip.

    This configuration `might be redundant <https://github.com/drduh/macOS-Security-and-Privacy-Guide/issues/283>`_ on APFS volumes, see

    Mind that this might make problems, at least on older Macs:

          If you choose to evict FileVault keys in standby mode, you should also modify
          your standby and power nap settings. Otherwise, your machine may wake while in
          standby mode and then power off due to the absence of the FileVault key.
          (https://github.com/drduh/macOS-Security-and-Privacy-Guide)

.. hint::
    It is always better to power off completely when not in use.

Values:
    - bool [default: false]

References:
    * man pmset
    * https://eclecticlight.co/2017/01/20/power-management-in-detail-using-pmset/
    * https://github.com/drduh/macOS-Security-and-Privacy-Guide


firewall
--------
Customizes state of inbuilt application firewall (blocks incoming connections only).

Values:
    - dict

        * apple_signed_ok: bool [default: true]
        * download_signed_ok: bool [default: false]
        * enabled: bool [default: true]
        * incoming_block: bool [default: false]
        * logging: bool [default: true]
        * stealth: bool [default: false]

.. hint::

    stealth mode: ignore ICMP ping or TCP/UDP connection attempts to closed ports


gatekeeper
----------
Customizes Gatekeeper activation status.

Values:
    - bool [default: true]


guest_account
-------------
Customizes Guest account availability.

Values:
    - bool [default: false]


internet_sharing
----------------
Customizes Internet Sharing status.

.. note::

    Not sure which service needs restarting, if any.

Values:
    - bool [default: false]


ipv6
----
Customizes IPv6 availability on all interfaces.

.. note::

    This is for documentation mostly. Debatable if sensible.

Values:
    - bool [default: true]

References:
    * https://github.com/SummitRoute/osxlockdown/blob/master/commands.yaml


mdns
----
Customizes activation status of multicast DNS advertisements.

.. note::

    The old method described in Awesome MacOS Command Line does not
    work on modern systems with System Integrity Protection.

References:
  https://git.herrbischoff.com/awesome-macos-command-line/about/#bonjour-service
  https://old.reddit.com/r/macsysadmin/comments/poxv5q/disabling_bonjour_on_bigsur/

Values:
    - bool [default: true]


ntp
---
Customizes NTP synchronization activation status and server.

Values:
    - dict

        * enabled: bool [default: true]
        * server: string [default: time.apple.com]


password_hint_after
-------------------
Customizes display of password hint (number of tries).

Values:
    - int [0 to disable, default 3?]


printer_sharing
---------------
Customizes state of printer sharing.

Values:
    - bool [default: false]


quarantine_logs
---------------
Customizes keeping of Quarantine logs.

.. hint::

    It's a bit surprising the logs are never cleared.

    See for yourself:
      echo 'SELECT datetime(LSQuarantineTimeStamp + 978307200, "unixepoch") as LSQuarantineTimeStamp, ' \
        'LSQuarantineAgentName, LSQuarantineOriginURLString, LSQuarantineDataURLString from LSQuarantineEvent;' | \
        sqlite3 /Users/$USER/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2

Values:
    - dict

        * clear: bool [default: false]
        * enabled: bool [default: true]


remote_apple_events
-------------------
Customizes activation state of Remote Apple Events.

Values:
    - bool [default: false]


remote_desktop_disabled
-----------------------
Allows to **disable** Remote Desktop services.

.. note::

    Enabling this might not work on MacOS Monterey 12.1 (from CLI) anyways.
    Disabling should work (from CLI).

Values:
    - bool [default: true]

References:
    * https://support.apple.com/guide/remote-desktop/enable-remote-management-apd8b1c65bd/mac
    * https://support.apple.com/en-us/HT209161


remote_login
------------
Customizes activation state of Remote Login (SSH server).

.. note::

    This used to be settable with systemsetup -setremotelogin,
    but that requires Full Disk Access now. Currently, a workaround
    is to manually load/unload the plist with launchctl.

Values:
    - bool [default: false]

References:
    * https://www.alansiu.net/2020/09/02/scripting-ssh-off-on-without-needing-a-pppc-tcc-profile/


require_admin_for_system_settings
---------------------------------
Customizes the requirement to authenticate as an admin to change
system-wide settings.

Values:
    - bool [default: true]

References:
    * https://github.com/SummitRoute/osxlockdown/blob/master/commands.yaml


root_disabled_check
-------------------
Checks if the root user is disabled.

.. hint::

    As an administrator, you can run `/usr/sbin/dsenableroot` to enable
    and `/usr/sbin/dsenableroot -d` to disable. The process is interactive.

Values:
    - bool [default: false]

References:
    * https://unix.stackexchange.com/questions/232491/how-to-test-if-root-user-is-enabled-in-mac


smartcard-only-auth
-------------------
Customizes state of forced smart card authentication.

.. note::

    You might need to reboot to apply changed settings. macOS 10.13.2 or later.

Values:
    - bool [default: false]

References;
    * https://support.apple.com/guide/deployment/configure-macos-smart-cardonly-authentication-depfce8de48b/1/web/1.0
    * https://support.apple.com/HT208372


sudo_touchid
------------
Customizes availability of Touch ID and pam_reattach for sudo authentication.

.. note::

    Since ``/etc/pam.d/sudo`` is reset after a system upgrade, you will
    need to reapply this state occasionally.

.. hint::

    pam_reattach might be needed for Touch ID authentication inside
    tmux sessions and iTerm saved sessions to work.

Values:
    - bool [default: false]
    - or dict:

        * enabled: bool [default: false]
        * pam_reattach: bool [default:false]

References;
    * https://derflounder.wordpress.com/2017/11/17/enabling-touch-id-authorization-for-sudo-on-macos-high-sierra/
    * https://akrabat.com/add-touchid-authentication-to-sudo/
    * https://github.com/fabianishere/pam_reattach


user_hidden
-----------
Manages visibility of user accounts.

.. hint::

    When turned on, this does three things:
        1) Hides the user account from the login window (not FileVault necessarily).
        2) Hides the home folder.
        3) Hides the public share folder.

    Handy for e.g. complex FileVault password that's different from your usual account
    (in combination with user_no_filevault).

Values:
    - bool [default: false]

References:
    * https://support.apple.com/en-gb/HT203998


user_no_filevault
-----------------
Removes FileVault unlock privileges from an account.

.. note::

    The reverse is interactive::

        `sudo fdesetup add -usertoadd username`

    Handy for e.g. complex FileVault password that's different from your usual account.

Values:
    - bool [default: false]

References:
    * https://support.apple.com/en-gb/HT203998


wake_on_lan
-----------
Manages state of Wake-on-LAN. This setting could be managed in macos.power
settings as well.

.. hint::

    Furthermore, this can be set with /usr/sbin/systemsetup setwakeonnetworkaccess

Values:
    - bool [default: on ac true, on battery false]


