<#
.SUMMARY
Day2_AoC-2019

#>
[CmdletBinding(DefaultParameterSetName="NounVerb")]
param (
    [parameter(ValueFromPipeline=$true)]
    [string]$Program,

    [parameter(ParameterSetName="NounVerb")]
    [int]$Noun,

    [parameter(ParameterSetName="NounVerb")]
    [int]$Verb,

    [parameter(ParameterSetName="DesiredValue",Mandatory=$true)]
    [int64]$Desired
)

begin {
    Function ProcessCode {
        param([int]$Position)

        switch ($Codes[$Position]) {
            1 { $Codes[$Codes[$Position+3]] = $Codes[$Codes[$Position+1]] + $Codes[$Codes[$Position+2]] }
            2 { $Codes[$Codes[$Position+3]] = $Codes[$Codes[$Position+1]] * $Codes[$Codes[$Position+2]] }
            99 { break }
        }
    }
    [int[]]$Codes = @()
}

process {
    switch ($PSCmdlet.ParameterSetName) {
        "DesiredValue" {
            $Found = $False
            For ($Noun=0;$Noun -lt 100;$Noun++) {
                For ($Verb=0; $Verb -lt 100; $Verb++) {
                    $Codes = [int[]]($Program -split ",")
                    $Pos = 0
                    $Codes[1] = $Noun
                    $Codes[2] = $Verb
                    While ($Codes[$Pos] -ne 99) {
                        If ($Codes[$Pos] -lt $Codes.Length -and
                            $Codes[$Pos+1] -lt $Codes.Length -and
                            $Codes[$Pos+2] -lt $Codes.Length -and
                            $Codes[$Pos+3] -lt $Codes.Length
                            ) {
                            ProcessCode -Position $Pos
                            $Pos += 4
                        } else {
                            Write-Host ("{0}`: {1}" -f $Pos,(($Pos..($Pos+3)|%{ $Codes[$_]}) -join ","))
                            break
                        }
                    }
                    If ($Codes[0] -eq $Desired) {
                        Write-Host "Noun: $Noun   Verb: $Verb   Error Code: $($Noun*100+$Verb)"
                        $Found = $true
                        break
                    }
                }
                If ($Found) { Break }
            }
        } 
        default {
            $Codes = [int[]]($Program -split ",")
            $Pos = 0

            If ($Noun) { $Codes[1]=$Noun }
            If ($Verb) { $Codes[2]=$Verb }

            While ($Codes[$Pos] -ne 99) {
                ProcessCode -Position $Pos
                $Pos += 4
            }
        }
    }
}

end {
    return ($Codes -join ",")
}

