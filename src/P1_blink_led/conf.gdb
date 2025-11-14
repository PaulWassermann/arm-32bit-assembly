# Connect to current OpenOCD session using TCP
target extended-remote :3333

# Flash binary to on-board memory
load

# Just in case, reset board
monitor reset halt