#enable Mouse Keys
function enable-mousekeys {
   # ProgressWriter -Status "Enabling mouse keys to assist with mouse cursor" -PercentComplete $PercentComplete
    set-Itemproperty -Path 'HKCU:\Control Panel\Accessibility\MouseKeys' -Name Flags -Value 63 | Out-Null
    }

enable-mousekeys