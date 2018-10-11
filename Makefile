# make is byzantine and obnoxious: https://stackoverflow.com/q/4122831/344821
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:
.PHONY: all clean clean-all

all: index.html biblio.bib cv.pdf

%: papers.yaml build.py templates/%
	python build.py $@

biblio.bib: biblio-cv.bib
	# This sed command wouldn't work if the \bibme argument has {}s in it,
	# e.g. because of an accent. Luckily my name doesn't...
	tail -n '+10' $< | sed -e 's/\\bibeqcon{}//g; s/\\bibme{\([^}]*\)}/\1/g; /addendum = /d' > $@

cv.pdf: cv.tex biblio-cv.bib
	mkdir -p .cv-build
	ln -f cv.tex .cv-build/
	cd .cv-build && latexmk -pdf cv
	ln -f .cv-build/cv.pdf .

clean:
	rm -rf .cv-build

clean-all: clean
	rm -f index.html biblio.bib biblio-cv.bib cv.pdf
