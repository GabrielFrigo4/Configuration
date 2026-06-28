param (
	[Parameter(Mandatory=$false)]
	[ValidateScript({Test-Path $_ -PathType Container})]
	[string]$Path = "."
)

$sourcePath = (Resolve-Path $Path).Path
$parentPath = Split-Path $sourcePath -Parent
$folderName = Split-Path $sourcePath -Leaf
$destRoot   = Join-Path $parentPath "${folderName}.pdf"

if (-not (Test-Path $destRoot)) {
	New-Item -ItemType Directory -Path $destRoot | Out-Null
}

$mdFiles = Get-ChildItem -Path $sourcePath -Filter "*.md" -Recurse | Where-Object { $_.FullName -notmatch [regex]::Escape($destRoot) }

foreach ($file in $mdFiles) {
	$relativePath = $file.DirectoryName.Substring($sourcePath.Length).TrimStart('\', '/')
	$targetDir    = Join-Path $destRoot $relativePath
	$outputFile   = Join-Path $targetDir ($file.BaseName + ".pdf")

	if (-not (Test-Path $targetDir)) {
		New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
	}

	Write-Host "Convertendo: $($file.Name) -> $($relativePath)/$($file.BaseName).pdf" -ForegroundColor Cyan

	pandoc $file.FullName -o $outputFile --pdf-engine=weasyprint -V margin-top=20mm -V margin-bottom=20mm -V margin-left=15mm -V margin-right=15mm
}

Write-Host "`nProcesso finalizado. PDFs salvos em: $destRoot" -ForegroundColor Green
