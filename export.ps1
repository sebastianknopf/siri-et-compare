# Notebook file name
$Notebook = "siri-et-compare.ipynb"

# Derive the HTML file name automatically
$HtmlFile = [System.IO.Path]::ChangeExtension($Notebook, "html")

# Export notebook to HTML without showing code cells
jupyter nbconvert `
    --to html `
    --output $HtmlFile `
    --TemplateExporter.exclude_input=True `
    $Notebook

if ($LASTEXITCODE -eq 0) {
    Write-Host "Export completed successfully: $HtmlFile"
} else {
    Write-Error "Export failed."
}