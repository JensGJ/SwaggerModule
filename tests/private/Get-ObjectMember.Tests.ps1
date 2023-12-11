BeforeAll {
  . $PSScriptRoot\..\_InitializeTests.ps1
}

Describe 'Get-ObjectMember' {
  InModuleScope SwaggerModule {
    Context 'when given an object with note properties' {
      It 'returns the correct number of properties' {
        $obj = [PSCustomObject]@{Name = 'John'; Age = 30 }
        $result = Get-ObjectMember -obj $obj
        $result.Count | Should -Be 2
      }
      Context 'when given an object with note properties' {
        It 'returns an array of objects' {
          $obj = [PSCustomObject]@{Name = 'John'; Age = 30 }
          $result = Get-ObjectMember -obj $obj
          $result.GetType().Name | Should -Be 'Object[]'
        }
      }
      Context 'when given an object without note properties' {
        It 'returns an empty array' {
          $obj = [PSCustomObject]@{Name = 'John'; Age = 30 }
          #$obj | Remove-Member -MemberType NoteProperty -Name Name, Age
          $obj = $obj | Select-Object -ExcludeProperty Name, Age
          $result = Get-ObjectMember -obj $obj
          $result | Should -Be @()
        }
      }
      Context 'when given an object with note properties' {
        It 'returns an array of objects' {
            $obj = [PSCustomObject]@{Name = 'John'; Age = 30}
            $result = Get-ObjectMember -obj $obj
            $result.Key | Should -Contain 'Name'
            $result.Value | Should -Contain 'John'
            $result.Key | Should -Contain 'Age'
            $result.Value | Should -Contain '30'

        }
    }
    }
  }
}