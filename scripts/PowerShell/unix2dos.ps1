$Extensions = @("*.sh", "*.ps1", "*.lua", "*.cmd", "*.md", "*.nu")
$Files = Get-ChildItem -Path . -Include $Extensions -Recurse -File

foreach ($File in $Files) {
	$Content = [System.IO.File]::ReadAllText($File.FullName)
	if ($Content -notmatch "`r`n" -and $Content -match "`n") {
		$Content = $Content -replace "`n", "`r`n"
		[System.IO.File]::WriteAllText($File.FullName, $Content)
		Write-Host "Convertido para CRLF: $($File.Name)" -ForegroundColor Cyan
	}
}
Write-Host "Processo concluído."
