function Get-SwaggerFile {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
      $path
  )

process{
# TODO: File info (filnavn, størrelse, antal linjer/ord, datoer)

  if (-not (Test-Path $path -PathType Leaf))
  {
    Write-Error "File not found ($path)";
    return
  }

  try {
      $swagger = Get-Content -Path $path -Encoding UTF8 -Raw  | ConvertFrom-Json -ErrorAction SilentlyContinue
      #$swagger = Get-Content -Path $path -Encoding UTF8 -Raw -erroraction Stop | ConvertFrom-Json

    }
  catch [System.ArgumentException] {
      Write-Error "Invalid JSON file: $path ($_)"
      return
  }
  catch {
          Write-Error "Unknown error: $($_.Exception.GetType().FullName)"
          Write-Error $_.Exception.Message
          return
   }

   $fileInfo = Get-ChildItem $path


   $restURI = Get-RestURI -swagger $swagger
#   if ($swagger.openapi){
#       $restURI = $swagger.servers.url
#   } else {

#       $restURI = ("{0}://{1}{2}" -f $swagger.schemes[0], $swagger.host, $swagger.basePath)
#   }



  $security =
  switch ($swagger) {
      {$_.components.securitySchemes.'x-api-key'} { "x-api-key"; break }
      {$_.securityDefinitions.'x-api-key'} { "x-api-key"; break }
      {$_.securityDefinitions.custom_scheme} {$_.securityDefinitions.custom_scheme.type; break}
      Default {"unknown"}
  }

  $paths = Get-SwaggerPath -swagger $swagger

  $serviceInfo = [ordered]@{
      Title = $swagger.info.title
      Version = $swagger.info.version
      BaseURL = $restURI
      Security = $security
      Paths = ($paths | Select-Object path,  @{N='parameters';E={$_.parameters -join ","}})
      PathsExpanded = ($paths | Format-List | Out-String)
      SwaggerFile = $fileInfo.FullName
      SwaggerDate = $fileInfo.LastWriteTime
      SwaggerLength = $fileInfo.Length
  }

  return New-Object -TypeName psobject -Property $serviceInfo
  # Output base info
#  $serviceInfo # | select Title, Version, BaseURL, Security


}

}


