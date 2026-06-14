# Notebook file name
$Notebook = "siri-et-compare.ipynb"

# Derive the HTML file name automatically
$MdFile = [System.IO.Path]::ChangeExtension($Notebook, "md")

# Export notebook to HTML without showing code cells
jupyter nbconvert `
    --to markdown `
    --output $MdFile `
    --TemplateExporter.exclude_input=True `
    --ExtractOutputPreprocessor.enabled=False `
    $Notebook

if ($LASTEXITCODE -eq 0) {
    Write-Host "Export completed successfully: $MdFile"
} else {
    Write-Error "Export failed."
}