BeforeAll{
  . $PSScriptRoot\..\_InitializeTests.ps1;
}
Describe 'Parse-Swaggerfile' {
  Context 'when given a valid JSON file' {
      It 'returns a hashtable with the correct service info' {

        #$json = '{"info": {"title": "My API", "version": "1.0"}, "servers": [{"url": "https://api.example.com"}], "securityDefinitions": {"x-api-key": {"type": "apiKey"}}}'
        #$validFile = 'TestDrive:\swagger.json';
        #New-Item -ItemType file -Path $validFile -Value $json -Verbose
        $validFile = "$PSScriptRoot\..\ValidSample.json"
        test-path $validFile | Should -BeTrue

          #Mock Get-Content { $json } -ParameterFilter { $path -eq 'C:\swagger.json' }
          $result = Parse-Swaggerfile -path $validFile
          $result.Title | Should -Be 'My API'
          $result.Version | Should -Be '1.0'
          $result.BaseURL | Should -Be 'https://api.example.com'
          $result.Security | Should -Be 'x-api-key'
      }
  }
  Context 'when given an invalid JSON file' {
      It 'returns an error message' {
          $invalidFile = 'TestDrive:\invalidswagger.json';
          New-Item -ItemType file -Path $invalidFile -Value "foo" -Verbose
          Parse-Swaggerfile -path $invalidFile -errorVariable PesterError -erroraction SilentlyContinue
          $pesterError.Count | Should -BeGreaterOrEqual 1
#          $scriptBlock | Should -Throw
      }
  }
  Context 'when given a non-existent file' {
      It 'returns an error message' {
          $path = 'TestDrive:\nofilehere.txt'
          Parse-Swaggerfile -path $path -errorVariable PesterError -erroraction SilentlyContinue
          $pesterError.Count | Should -BeGreaterOrEqual 1
      }
  }

}
