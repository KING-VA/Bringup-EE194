import pylink

jlink = pylink.JLink()

# TODO: Replace with the serial number of the J-Link
jlink.open(serial_no=123456789)

# For debugging purposes, print out connection information
print(jlink.product_name)

# Connect to the target device
# TODO: Replace with the serial number of the target device
jlink.connect('MKxxxxxxxxxx7')

# Read the device ID and other information
print(jlink.core_id())
print(jlink.device_family())
print(jlink.target_connected())

