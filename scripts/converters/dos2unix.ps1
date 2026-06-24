$Extensions = @("*.sh", "*.ps1", "*.lua", "*.cmd", "*.md", "*.nu")
$Files = Get-ChildItem -Path . -Include $Extensions -Recurse -File

foreach ($File in $Files) {
	$Content = [System.IO.File]::ReadAllText($File.FullName)
	if ($Content -match "`r`n") {
		$Content = $Content -replace "`r`n", "`n"
		[System.IO.File]::WriteAllText($File.FullName, $Content, (New-Object System.Text.UTF8Encoding($false)))
		Write-Host "Convertido para LF: $($File.Name)" -ForegroundColor Green
	}
}
Write-Host "Processo concluído."
