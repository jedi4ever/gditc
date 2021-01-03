# Execute the ndi tools script
"c:\Program Files (x86)\AutoIt3\AutoIt3.exe" c:\scripts\ndi-tools.au3

# And disable ourselves as a task because we only need to run once
schtasks /Change /TN "ndi tools auto installer" /Disable
