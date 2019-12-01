<#
.SUMMARY
Day1_AoC-2019

#>
[Cmdletbinding()]
param([parameter(ValueFromPipeline=$true)][int64]$ModuleMass,
    [switch]$IncludeFuel)

Begin {
    Function GetFuel {
        Param([int64]$Mass,
            [switch]$Recurse)

        If ($Mass -ge 9) {
            $Fuel = [math]::Floor($Mass/3)-2
            If ($Recurse) {
                $Fuel += GetFuel -Mass $Fuel -Recurse:$Recurse
            } 
            return $Fuel 
        } else {
            return 0
        }
    }

    $TotalFuel = 0
}

Process {
    $ThisFuel = GetFuel -Mass $ModuleMass
    If ($IncludeFuel) {
        $ThisFuel += GetFuel -Mass $ThisFuel -Recurse
    }
    $TotalFuel += $ThisFuel 
}

End {
    return $TotalFuel
}