Show all processes in Activity Monitory:
  macdefaults.write:
    - domain: com.apple.ActivityMonitor
    - name: ShowCategory
    - value: 100
    - vtype: int
    - user: {{ user.name }}

# Show processes in Activity Monitor
# 100: All Processes
# 101: All Processes, Hierarchally
# 102: My Processes
# 103: System Processes
# 104: Other User Processes
# 105: Active Processes
# 106: Inactive Processes
# 106: Inactive Processes
# 107: Windowed Processes

# https://github.com/joeyhoer/starter/blob/master/apps/activity-monitor.sh

# @TODO
# Set columns for each tab
# defaults write com.apple.ActivityMonitor "UserColumnsPerTab v5.0" -dict \
#     '0' '( Command, CPUUsage, CPUTime, Threads, IdleWakeUps, PID, UID )' \
#     '1' '( Command, anonymousMemory, compressedMemory, ResidentSize, ' \
#           'PurgeableMem, Threads, Ports, PID, UID)' \
#     '2' '( Command, PowerScore, 12HRPower, AppSleep, graphicCard, UID )' \
#     '3' '( Command, bytesWritten, bytesRead, Architecture, PID, UID )' \
#     '4' '( Command, txBytes, rxBytes, txPackets, rxPackets, PID, UID )'

# Sort columns in each tab
# defaults write com.apple.ActivityMonitor UserColumnSortPerTab -dict \
#     '0' '{ direction = 0; sort = CPUUsage; }' \
#     '1' '{ direction = 0; sort = ResidentSize; }' \
#     '2' '{ direction = 0; sort = 12HRPower; }' \
#     '3' '{ direction = 0; sort = bytesWritten; }' \
#     '4' '{ direction = 0; sort = txBytes; }'

# Update Frequency (in seconds)
# 1: Very often (1 sec)
# 2: Often (2 sec)
# 5: Normally (5 sec)
# defaults write com.apple.ActivityMonitor UpdatePeriod -int 2

# Show Data in the Disk graph (instead of IO)
# defaults write com.apple.ActivityMonitor DiskGraphType -int 1

# Show Data in the Network graph (instead of packets)
# defaults write com.apple.ActivityMonitor NetworkGraphType -int 1

# Change Dock Icon
# 0: Application Icon
# 2: Network Usage
# 3: Disk Activity
# 5: CPU Usage
# 6: CPU History
# defaults write com.apple.ActivityMonitor IconType -int 0
