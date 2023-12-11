function Get-ParameterInfo {
  param (
      # Parameter help description
      [Parameter(Mandatory=$true)]
      [PSCustomObject]
      $parameterObject
  )

  $parameterInfo = ""
  switch ($parameterObject.Count) {
      0 { break; }
      1 {
          $parameterInfo = $parameterobject | Format-List  Name, Type, Required, Description  | Out-String
          break;
       }
      Default {
          $parameterInfo = ($parameterObject | format-table name, required, type, description -autosize | out-string  );
          break;
      }
  }

  return $parameterInfo.Trim()
}