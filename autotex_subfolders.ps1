$path = "C:\Users\User\Dropbox\AUTOCOMPILE\"
cd $path

# run this script until infinity or the next Windows crash
while($true){

$subfolders = Get-ChildItem | ?{ $_.PSIsContainer } | Select-Object FullName
foreach ($j in $subfolders) {

	$files = gci -Path $j.FullName "*.tex"

	# check all TeX files in the $files array
	foreach ($i in $files) {
	   # Name of the PDF file
	   $pdfpath = $j.FullName+ "\" + $i.BaseName + ".pdf"

	   if (Test-Path -path $pdfpath){
			   "A PDF for $i exists"
			   $pdf = gci $pdfpath
			   if ($i.LastWriteTime -gt $pdf.LastWriteTime) {
				  "TeX file is newer, let's create the PDF!"
				  pdflatex -interaction=nonstopmode -output-directory $j.FullName $i.FullName
				}
				else {
				  "but the PDF is newer, so no compilation is needed"
				}	

		} 
		else {
				"No PDF found for $i, let's create it!"
				 pdflatex -interaction=nonstopmode -output-directory $j.FullName $i.FullName
		}
	}
}
# wait defined seconds before your start over again
Start-Sleep -Seconds 300

}