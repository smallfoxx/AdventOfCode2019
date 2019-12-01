<#
.SUMMARY
Day1_AoC-2019

#>
[Cmdletbinding()]
param([parameter(ValueFromPipeline=$true)][int64]$ModuleMass)

Begin {
    $TotalFuel = 0
}

Process {
    $TotalFuel += [math]::Floor($ModuleMass/3)-2
}

End {
    return $TotalFuel
}