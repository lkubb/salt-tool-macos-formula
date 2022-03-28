.. _toolsuite:

Note on general `tool` suite architecture
=========================================

Since configuring **user** environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All ``tool`` formulae currently assume running as root.

Configuration
-------------

Scopes
~~~~~~
Conceptually, there are three scopes of configuration:

1. per-user ``tool`` suite-specific

    \e.g. generally force usage of XDG dirs in ``tool`` formulae for this user

2. per-user formula-specific

    \e.g. setup this tool with the following configuration values for this user

3. global formula-specific (All formulae will accept ``defaults`` for ``users:<username>:<tool>`` default values in this scope as well.)

    \e.g. setup system-wide configuration files like this

**3** lives in ``tool_<tool>`` (e.g. ``tool_git``). Both user scopes (**1** + **2**) are mixed per user found in ``users``. ``users`` can be defined in ``tool_global:users`` and/or `tool_<tool>:users`, the latter taking precedence. (**1**) is namespaced directly under ``<username>``, (**2**) is namespaced under ``username:<tool>``.

.. code-block:: yaml

  tool_global:
  ######### user-scope 1+2 #########
    users:                         #
      username:                    #
        xdg: true                  #
        dotconfig: true            #
        <tool>:                    #
          config: value            #
  ####### user-scope 1+2 end #######
  tool_<tool>:
  ######### user-scope 1+2 #########
    users:                         #
      username:                    #
        xdg: false                 #
        <tool>:                    #
          userconfig: otherval     #
  ####### user-scope 1+2 end #######
    formulaspecificstuff:
      conf: val
    defaults:  # for username:<tool>
      yetanotherconfig: somevalue

Parameter merging
~~~~~~~~~~~~~~~~~
The above description focused on pillar values explicitly. Mind that you do not need to dump everything in there by default. All ``tool`` formulae perform rather heavy merging from a variety of sources by default, of which the first and last two are matched by grain (first: ``osarch``, ``os_family``, ``os``, ``osfinger``. last: ``id``) values implicitly (file server URL):

1. ``salt://tool_global/parameters/<grain>/<value>.yaml[.jinja]``

    analogous to ``tool_global`` pillar

2. ``salt://tool_<tool>/parameters/<grain>/<value>.yaml[.jinja]``

    analogous to ``tool_<tool>`` pillar

3. ``tool_global:users`` one of [master config] < pillar < grain < minion config values

    .. hint::

      Behind the scenes, ``config.get`` is used and returns the first match, so there is **no merging for these sources**. Same goes for the next step.

4. ``tool_<tool>`` one of [master config] < pillar < grain < minion config values
5. ``salt://tool_global/parameters/id/<value>.yaml[.jinja]``
6. ``salt://tool_<tool>/parameters/id/<value>.yaml[.jinja]``


The above lists are always in **ascending** priority.

.. hint::

  This implies that it is possible for ``tool_global`` YAML values targeted by ID to override ``tool_<tool>`` values with lesser priority, including pillar ones, by default.

For further details on where and how to specify those values and how to modify the default behavior, see :ref:`map.jinja`.
