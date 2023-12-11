function Get-RestURI{
  [CmdletBinding(DefaultParameterSetName='File')]
  [OutputType([String])]
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
  if ($swagger.servers.url){
    return $swagger.servers.url;
  }
  if ($swagger.schemes -and $swagger.host -and $swagger.basePath){
    return ("{0}://{1}{2}" -f $swagger.schemes[0], $swagger.host, $swagger.basePath)
  }

  return "Unknown"
}
