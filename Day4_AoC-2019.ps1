<#
.SUMMARY
Day4_AoC-2019

#>
[CmdletBinding(DefaultParameterSetName="maxMin")]
param (
    [parameter(ParameterSetName="StringRange",Mandatory=$true,ValueFromPipeline=$true)]
    [string]$Range,

    [parameter(ParameterSetName="MaxMin",ValueFromPipelineByPropertyName=$true)]
    [int64]$Min=123257,

    [parameter(ParameterSetName="MaxMin",ValueFromPipelineByPropertyName=$true)]
    [int64]$Max=647015,

    [Alias('Part2','PartTwo')]
    [switch]$LargestDouble,

    [switch]$FindValues
)

begin {
    Function ValidPassword {
        param(
            [parameter(ValueFromPipeline=$true)]
            [int64]$Pwd,

            [switch]$CheckForLargeDouble,

            [switch]$ReturnValueOnTrue
        )

    Process {
        $PwdChars = [char[]][string]$pwd
        $PrevChar = 0
        $Doubles = @()
        $TooLong = @()
        ForEach ($Char in $PwdChars) {
            $CurCharInt = [int]$Char
            If ($PrevChar -gt $CurCharInt) {
                If (-not $ReturnValueOnTrue) {
                    return $False
                } else {
                    return
                }
                break
            } elseif ($PrevChar -eq $CurCharInt) {
                if ($CheckForLargeDouble -and ($Doubles -contains $CurCharInt)) {
                    $TooLong += $CurCharInt
                } else {
                    $Doubles += $CurCharInt
                } 
            }
            $PrevChar = $CurCharInt
        }
        $Doubles = $Doubles | Where-Object { $TooLong -notcontains $_ }
        If ($Doubles) {
            If ($ReturnValueOnTrue) {
                return $Pwd
            } else {
                return $true
            }
        }
    }
    }

}

process {
    If ($Range -match "\A(?<min>\d+)-(?<max>\d+)\Z") {
        $Min = $Matches.min
        $Max = $Matches.max
    }
    $Min..$Max | ValidPassword -ReturnValueOnTrue:$FindValues -CheckForLargeDouble:$LargestDouble
}

end {

}

