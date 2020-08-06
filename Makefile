

# 3. Combining all output
.PHONY: all
all: clean force Ryan_Larson-Graphics_Application.pdf
Ryan_Larson-Graphics_Application.pdf: build/resume.pdf build/cover.pdf build/examples.pdf
	pdftk $^ cat output $@


# 2. Building individual PDFs
.PHONY: builds
builds: build/resume.pdf build/examples.pdf build/cover.pdf
build/resume.pdf: src/resume/*.tex
build/examples.pdf: src/images/di.png src/images/college.png src/images/CarSentoGram.png
build/%.pdf: src/%.tex src/%/*.tex src/awesome-cv.cls src/shared.tex
	cd src && xelatex -no-file-line-error $(notdir $<)
	mv $(basename $<).pdf $@
	rm $(basename $<).{log,aux,out,fls,synctex.gz,fdb_landmark} -f


# 1. Building output graphics
src/images/college.png: src/images/cropped_0.png src/images/cropped_1.png src/images/cropped_2.png
	convert $^ +append $@
	# convert $@ -scale 50% $@

src/images/di.png: src/images/di-*.png
	montage $^ -border 10 -background '#ffffff' -bordercolor '#ffffff' -tile 2x -geometry +0+0 $@


# 0. Clean command
.PHONY: clean force
clean :
	find . -type f -name '*.log' -exec rm {} +
	find . -type f -name '*.aux' -exec rm {} +
	find . -type f -name '*.out' -exec rm {} +
	find . -type f -name '*.fls' -exec rm {} +
	find . -type f -name '*.synctex.gz' -exec rm {} +
	rm -f build/*
force:
	touch src/*.tex src/images/{di-*,CarSentoGram}.png

build/resume.txt: src/resume.tex
	# Convert resume tex to unified text file
	cd src && detex $(notdir $<) > ../$@
	# Remove empty (non char) lines from text file
	sed -i '/^[[:space:]]*$$/d;s/[[:space:]]*$$//' $@
	# Remove cruft from latex preamble
	tail -n +7 $@ > $@.tmp && mv $@.tmp $@
