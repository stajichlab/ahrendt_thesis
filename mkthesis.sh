# Run R CMD Sweave in "./Chapter_Inhibition/tab/" on "Ahrendt_thesis_ChInhibition_Tabs.Rnw"

TEX="Ahrendt_thesis.tex"
pdflatex $TEX
bibtex $TEX
pdflatex $TEX
pdflatex $TEX
