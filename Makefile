
# __  __       _         __ _ _
#|  \/  | __ _| | _____ / _(_) | ___
#| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
#| |  | | (_| |   <  __/  _| | |  __/
#|_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#

###################################################

PDFEXE    = pdflatex --shell-escape
BIBEXE    = bibtex
PDFTEST   = mupdf

MINSRC    = cv.tex
MAXSRC	  = '\providecommand{\fullresume{true}}\input{${MINSRC}}'
LETSRC    = body.tex
BIBSRC    = bibliography.bib

MINFILE   = amlesh_resume.pdf
MAXFILE   = amlesh_resume_full.pdf
LETFILE   = amlesh_cover_letter.pdf

MISCFILE  = ${MINSRC:.tex=.aux} \
	    ${MINSRC:.tex=.log} \
	    ${MINSRC:.tex=.dvi} \
	    ${MINSRC:.tex=.out} \
	    ${MINSRC:.tex=.bbl} \
	    ${MINSRC:.tex=.blg} \
	    ${MINSRC:.tex=.toc} \
        ${LETSRC:.tex=.aux} \
	    ${LETSRC:.tex=.log} \
	    ${LETSRC:.tex=.dvi} \
	    ${LETSRC:.tex=.out} \
	    ${LETSRC:.tex=.bbl} \
	    ${LETSRC:.tex=.blg} \
	    ${LETSRC:.tex=.toc} \

MAKEARGS  = --no-print-directory -C

####################################################

# Build both versions of the resume and view them.
pdf: single-page full coverletter
	${PDFTEST} ${MINFILE}
	${PDFTEST} ${MAXFILE}
	${PDFTEST} ${LETFILE}

# Build instructions for the single page resume
single-page: ${MINSRC} ${BIBSRC}
#	-${PDFEXE} ${MINSRC}
#	-${BIBEXE} ${MINSRC:.tex=.aux}
#	-${PDFEXE} ${MINSRC}
	-${PDFEXE} ${MINSRC}
	mv ${MINSRC:.tex=.pdf} ${MINFILE}

# Build instructions for the full resume
full: ${MINSRC} ${BIBSRC}
#	-${PDFEXE} ${MAXSRC}
#	-${BIBEXE} ${MAXSRC:.tex=.aux}
#	-${PDFEXE} ${MAXSRC}
	-${PDFEXE} ${MAXSRC}
	mv ${MINSRC:.tex=.pdf} ${MAXFILE}

coverletter: ${LETSRC}
	-${PDFEXE} ${LETSRC}
	mv ${LETSRC:.tex=.pdf} ${LETFILE}
	

# Clean the build directory
clean:
	-rm -fv ${MISCFILE}
	-rm -rfv _minted*/
	-rm -rf .svg/

# clean the directory and move the pdfs into the docs directory
spotless: clean
	-rm ${MINSRC:.tex=.pdf}
	-mv ${MINFILE} docs/
	-mv ${MAXFILE} docs/
	-rm ${LETFILE}

# spotless + pdf...
refresh: spotless pdf

# Run spotless, but also check in changes with git
ci: spotless
	git add .
	git commit -e
