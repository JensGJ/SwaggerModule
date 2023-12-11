function Get-SwaggerPath{
  [CmdletBinding(DefaultParameterSetName='File')]
#  [OutputType([String])]
  param (
    [Parameter(Mandatory=$true, ParameterSetName='File', Position=0)]
    [string]
      $filePath,

      # Parameter help description
      [Parameter(Mandatory=$true, ParameterSetName='Object')]
      [PSCustomObject]
      $swagger
  )
  if ($filePath){
    $swagger = Get-Content $filePath -Raw | ConvertFrom-Json
  }

  if (-not $swagger.paths){
    Write-Verbose "No paths found"
    return
  }

  $restURI = Get-RestURI -swagger $swagger



  $swagger.paths | Get-ObjectMember | ForEach-Object {
    # For every path
    $path =  $_.Key
#        $methodJSON =
    $_.Value | Get-ObjectMember | ForEach-Object {
        [pscustomobject]@{
            path    = $path
            fullPath = $restURI+$path
            method = $_.Key
            parameters =  $_.Value.parameters.name
            parameterCount = $_.Value.parameters.count
            parameterInfo = (Get-ParameterInfo   ($_.value.parameters))
            #parameterInfo = ($_.Value.parameters | format-table name, required, type, description -autosize | out-string  ).trim()
        }


    }
}
}
