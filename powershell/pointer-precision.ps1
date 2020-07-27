#Enable Pointer Precision 
function enhance-pointer-precision {
   # ProgressWriter -Status "Enabling enchanced pointer precision" -PercentComplete $PercentComplete
    Set-Itemproperty -Path 'HKCU:\Control Panel\Mouse' -Name MouseSpeed -Value 1 | Out-Null
}

enhance-pointer-precision