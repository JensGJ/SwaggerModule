function Get-ObjectMember {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
    [PSCustomObject]$obj
  )
  process {
    $obj | Get-Member -MemberType NoteProperty | ForEach-Object {
      $key = $_.Name
      [PSCustomObject]@{Key = $key; Value = $obj."$key" }
    }
  }
}