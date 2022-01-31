Mail
====

accounts
--------
    Allows to configure mail accounts for Apple Mail.

    .. note::

        This will install a configuration profile interactively. The user
        has to accept the installation manually.
        Full Disk Access on your terminal emulator application is not required.

    Values:
        - list of dicts

            * address: string
            * description: string [default: <address>]
            * name: string [default: <username part of address>]
            * type: string [imap, pop. default: imap]
            * server_in:

                - auth: string [default: password]

                    * none
                    * password
                    * crammd5
                    * ntlm
                    * httpmd5

                - domain: string
                - port: int [default: 993]
                - ssl: bool [default: true]
                - username: string [default: <address>]

            * server_out:

                - auth: string [default: password]
                - domain: string
                - port: int [default: 465]
                - ssl: bool [default: true]
                - username: string [default: <address>]
                - password_sameas_in: bool [default: true]

    Example:

    .. code-block:: yaml

        accounts:
          - address: elliotalderson@protonmail.ch
            description: dox
            name: Elliot
            server_in:
              domain: 127.0.0.1
              port: 1143
            server_out:
              domain: 127.0.0.1
              port: 1025

animation_reply
---------------
    Customizes activation status of reply animation.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]


animation_sent
--------------
    Customizes activation status of sent animation.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]

attachments_inline
------------------
    Customizes whether to show attachments inline.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values: bool [default: true]

auto_resend_later
-----------------
    Customizes whether to automatically resend outgoing messages when the server
    was not available (does not warn about failed sends).

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true?]

conv_mark_all_read
------------------
    Customizes whether to mark all messages as read when viewing conversation.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: false]

conv_most_recent_top
--------------------
    Customizes whether to show most recent message on top when viewing conversation.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]

dock_unread_count
-----------------
    Customizes dock unread messages count of Mail.app.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    .. hint::

        This is implemented as string because in theory, it allows
        to select smart mailboxes etc. (status of 4, set MailDockBadgeMailbox to smartmailbox://<UID>) @TODO?

    Values:
        - string [default: inbox]

            * all
            * inbox

downloads_remove
----------------
    Customizes condition to delete downloaded attachments.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - string [default: message_deleted]

            * app_quit
            * message_deleted
            * never

format_match_reply
------------------
    Customizes whether to automatically match a mail's format when replying.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]

format_preferred
----------------
    Customizes whether to prefer sending plaintext or richtext messages.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - string [default: rich]

            * plain
            * rich

highlight_related
-----------------
    Customizes whether to highlight conversations by color when not grouped.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true?]

include_names_oncopy
--------------------
    Customizes whether to include recipient names when copying mail addresses.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]

include_related
---------------
    Customizes whether to include related messages in conversation view.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]

new_message_notifications
-------------------------
    Customizes condition to receive new message alerts.

    .. note:

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:

        - string [default: inbox]

            * inbox
            * vips
            * contacts
            * all

new_message_sound
-----------------
    Customizes Mail.app new message alert sound.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - string [default: New Mail]

              * Basso
              * Blow
              * Bottle
              * Frog
              * Funk
              * Glass
              * Hero
              * Morse
              * Ping
              * Pop
              * Purr
              * Sosumi
              * Submarine
              * Tink

poll
----
    Customizes Mail.app polling behavior.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - str [default: auto]

            * auto
            * manual

        - or int [minutes between polls]

remote_content
---------------
    Customizes activation status of loading remote content.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]

respond_with_quote
------------------
    Customizes whether to quote the original mail when sending a reply.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]

shortcut_send
-------------
    Customizes shortcut to send mails.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - string [example: '@\U21a9' for Cmd+Enter]

    References:
        * https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/TextDefaultsBindings/TextDefaultsBindings.html
        * https://web.archive.org/web/20160314030051/http://osxnotes.net/keybindings.html
        * https://github.com/ttscoff/KeyBindings

unread_bold
-----------
    Customizes whether to display unread messages in bold font.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: false]

view_conversations
------------------
    Customizes whether to view messages grouped by conversation by default.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]

view_conversations_highlight
----------------------------
    Customizes whether to highlight collapsed conversations.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: false?]

view_date_time
---------------
    Customizes whether to display date and time in overview.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: false]

view_fullscreen_split
---------------------
    Customizes whether to prefer to preview messages in split view when in fullscreen mode.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]

view_message_size
-----------------
    Customizes whether to display message size in overview.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: false]
