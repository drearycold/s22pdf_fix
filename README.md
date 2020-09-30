# s22pdf_fix

* prepare simsun.ttf simhei.ttf simkai.ttf
* mutool run fix-s22pdf-embed.js input.pdf temp1.pdf
* pdftk temp1.pdf output temp2.pdf uncompress
* cat temp2.pdf | perl fix.pl > temp3.pdf
* mutool clean -z temp3.pdf output.pdf
