{#-
    Customizes eviction of FileVault keys on standby. When enabled,
    that means you need to re-enter your encryption password during wakeup
    from hibernation.

    .. note::

        This might not make a big difference on current M1 Macs and those with
        T2 security chip:
          https://discussions.apple.com/thread/253568420

        This configuration might be redundant on APFS volumes, see
        https://github.com/drduh/macOS-Security-and-Privacy-Guide/issues/283

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
-#}

{#- MacOS terminology is a bit all over the place and I'm not sure if I
    understood everything correctly. From what I understood, there are
    different Standby modes:

    Sleep (hibernatemode = 0):
      power to RAM intact
    Safe Sleep (hibernatemode = 3):
      power to RAM intact,
      RAM contents written to disk in case of failure
    Full hibernation (hibernatemode = 25):
      power to RAM shut off
      RAM contents written to disk

    There are also autopoweroff (frame: ac) / standby (frame: battery) settings.
      standby: 0/1 (enable sleep -> hibernation change)
      standbydelayhigh / standbydelaylow: time from sleep -> standby
      highstandbythreshold: percent of battery for standbydelayhigh to be active

      autopoweroff: 0/1 (enable)
      autopoweroffdelay: x [in seconds]

    For an overview, see https://apple.stackexchange.com/a/262593
#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- if macos.security is defined and macos.security.filevault_evict_keys_standby is defined %}
  {%- if macos.security.filevault_evict_keys_standby %}

    {#- This wall of ifs tries to protect from misconfiguration of this formula.
        Destroying filevault keys on standby only makes sense when RAM is not
        powered during standby. -#}
    {%- set hibernatemode_managed_and_wrong = None %}
    {%- if macos.power is defined %}
      {%- for scope, settings in macos.power %}
        {%- if 'hibernatemode' in settings.keys() | map('lower') %}
          {%- if '25' == str(settings.get('hibernatemode')) %}
            {#- force lowercase hibernatemode to be sure #}
            {%- set hibernatemode_managed_and_wrong = False %}
          {%- else %}
            {%- set hibernatemode_managed_and_wrong = True %}
          {%- endif %}
        {%- endif %}
      {%- endfor %}
    {%- endif %}

    {%- if hibernatemode_managed_and_wrong is not sameas None %}
Hibernatemode is managed and checked:
  test.{{ 'fail_without_changes' if hibernatemode_managed_and_wrong else 'nop' }}:
    - name: {{  'You specified hibernatemode in macos.power settings, but the value' ~
                ' is different than what is needed for destroyfvkeyonstandby.' if hibernatemode_managed_and_wrong
              else 'Hibernatemode is managed, but not in conflict.' }}
    {%- endif %}

RAM is not powered during standby:
  pmset.set:
    - name: hibernatemode
    - value: 25
    {%- if hibernatemode_managed_and_wrong is not sameas None %}
    - require:
      - Hibernatemode is managed and checked
    {%- endif %}

FileVault keys are destroyed when going to hibernate:
  pmset.set:
    - name: destroyfvkeyonstandby
    - value: 1
    - require: RAM is not powered during standby

# this might be needed to avoid crashes when destroying filevault keys on standby for older macs:
#   pmset.set:
#     - value:
#         powernap: 0
#         standby: 0
#         standbydelayhigh: 0  # surpassed standbydelay in Mojave
#         standbydelaylow: 0   # surpassed standbydelay in Mojave
#         autopoweroff: 0

  {%- else %}

FileVault keys are not destroyed when going to hibernate:
  pmset.set:
    - name: destroyfvkeyonstandby
    - value: 0
  {%- endif %}
{%- endif %}
