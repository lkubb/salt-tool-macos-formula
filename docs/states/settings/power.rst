Power
=====

Customizes power settings.

Values:
    - dict of ``<scope> => {name: val, othername: otherval}`` mappings
      where scope is in ``[all, ac, battery, ups]``.

Example:

.. code-block:: yaml

    power:
      all:
        standby: 1
        destroyfvkeysonstandby: 0
      ac:
        displaysleep: 10
        halfdim: 1
      battery:
        displaysleep: 5
        halfdim: 0
        lessbright: 1

References:
    * man pmset
    * https://en.wikipedia.org/wiki/Pmset
    * https://apple.stackexchange.com/a/262593

.. contents::
   :local:


