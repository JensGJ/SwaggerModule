function Get-ParameterInfo {
  param (
      # Parameter help description
      [Parameter(Mandatory=$true)]
      [PSCustomObject]
      $parameterObject
  )

  $parameterInfo = ""

try {
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

}
catch {
    Write-Verbose "Error retrieving parameterinfo (possible explanation: No parameters for the current path)"
}
  return $parameterInfo.Trim()
}