<#
.SUMMARY
Day3_AoC-2019

#>
[CmdletBinding(DefaultParameterSetName="PipelineMovement")]
param (
    [parameter(ValueFromPipeline=$true,ParameterSetName="PipelineMovement")]
    [string]$Movement,

    [switch]$FindClosest
)

begin {
    Function ProcessMove {
        param([int[]]$Coord,
            [string]$Direction,
            [int]$Velocity,
            [string]$Identity)

        $Coordinates.$Coord += @($Identity)
        If ($Velocity -le 0) {
            return $Coord
        } else {
            #Write-host "$Direction - $Velocity"
            $Next = switch ($Direction) {
                'R' { @(($Coord[0]+1),$Coord[1]) }
                'L' { @(($Coord[0]-1),$Coord[1]) }
                'U' { @($Coord[0],($Coord[1]+1)) }
                'D' { @($Coord[0],($Coord[1]-1)) }
            }
            ProcessMove -Coord $Next -Direction $Direction -Velocity ($Velocity-1) -Identity $Identity
        }
    }
    Function ProcessMoveLines {
        param([int[]]$Coord,
            [string]$Direction,
            [int]$Velocity,
            [string]$Identity)

        
        $Coordinates.$Coord += @($Identity)
        If ($Velocity -le 0) {
            return $Coord
        } else {
            Write-host "$Direction - $Velocity [$($Velocity.GetType())] ... [$($global:Lines.count)]" -NoNewline
            $EndPoint = switch ($Direction) {
                'R' { @(($Coord[0]+1),$Coord[1]) }
                'L' { @(($Coord[0]-1),$Coord[1]) }
                'U' { @($Coord[0],($Coord[1]+1)) }
                'D' { @($Coord[0],($Coord[1]-1)) }
            }
            $NewLine = New-Object PSObject -Property @{
                Start = $Coord
                End = $EndPoint
                Identity = $Identity
            }
            $NewLine | Add-Member ScriptProperty Slope {
                $xdiff = $this.End[0] - $this.Start[0]
                If ($xdiff -eq 0) {
                    return $null
                } else {
                    return (($this.End[1]-$this.Start[1])/$xdiff)
                }
            }
            $global:Lines += $NewLine
            Write-host " - [$($global:Lines.count)]"
            return $EndPoint
        }
    }
    Function GetIntersects {

        $inter = @()

        Write-host "Processing [$($global:lines.count)] lines..."
        For ($l1=0; $l1 -lt ($global:lines.count-1); $l1++) {
            for ($l2=$l1+1; $l2 -lt $global:lines.Count; $l2++) {
                $line1 = $global:lines[$l1]
                $line2 = $global:lines[$l2]
                if ($line1.Slope -eq $line2.Slope) {
                    #parallel; can't intersect
                } elseif ($line1.Slope -eq 0) {
                    If (($line1.Start[0] -lt $line2.start[0] -and $line1.End[0] -gt $line2.start[0]) -or 
                        ($line1.Start[0] -gt $line2.start[0] -and $line1.End[0] -lt $line2.start[0])) {
                            If (($line1.Start[1] -lt $line2.start[1] -and $line1.Start[1] -gt $line2.end[1]) -or 
                                ($line1.Start[1] -gt $line2.start[1] -and $line1.Start[1] -lt $line2.end[1])) {
                            $inter += @($line2.Start[0],$line1.Start[1])
                        }
                    }
                } else {
                    If (($line1.Start[0] -lt $line2.start[0] -and $line1.End[0] -gt $line2.start[0]) -or 
                        ($line1.Start[0] -gt $line2.start[0] -and $line1.End[0] -lt $line2.start[0])) {
                            If (($line1.Start[1] -lt $line2.start[1] -and $line1.Start[1] -gt $line2.end[1]) -or 
                                ($line1.Start[1] -gt $line2.start[1] -and $line1.Start[1] -lt $line2.end[1])) {
                                $inter += @($line1.Start[0],$line2.Start[1])
                        }
                    }
                }
            }
        }
        return $Inter
        <#ForEach ($Coords in $Coordinates.Keys) {
            If ($Coordinates.$Coords.Count -gt 1) {
                [int[]]$Coords
            }
        }#>
    }
    $Coordinates = @{}
    #New-Variable -Name Lines -Value @() -Scope Global
    $global:Lines = @()
    $CurrentCoord = @(0,0)
    $Iteration = 0
}

process {
    if ($Movement -match "\A(?<dir>\D+)(?<vel>\d+)\Z") {
        $CurrCoord = $CurrentCoord
        #write-host ("{0} - {1}" -f $matches.dir,$matches.vel)
        $CurrentCoord = ProcessMoveLines -Coord $CurrentCoord -Direction $Matches.dir -Velocity ([int]($Matches.vel)) -Identity "$Iteration-$Movement" 
        #$CurrCoord = ProcessMove -Coord $CurrCoord -Direction $Matches.dir -Velocity $Matches.vel -Identity "$Iteration-$Movement" 
        $Iteration++
    }
}

end {
    $Intersects = GetIntersects
    $Intersects | Add-Member ScriptProperty Distance { $this[0]+$this[1] }
    If ($FindClosest) {
        $closest = $Intersects | Sort-Object Distance | Select-Object -Last 1
        write-host "$closest"
        return ("({0}, {1}) - {2}" -f $Closest[0],$closest[1],($Closest[0]+$closest[1]))
        #$Intersects
    }
}

