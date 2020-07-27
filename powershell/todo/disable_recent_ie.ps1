#cleanup recent files
function clean-up-recent {
    ProgressWriter -Status "Delete recently accessed files list from Windows Explorer" -PercentComplete $PercentComplete
    remove-item "$env:APPDATA\Microsoft\Windows\Recent\*" -Recurse -Force | Out-Null
    }