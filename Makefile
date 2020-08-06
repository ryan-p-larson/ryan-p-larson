



# 3. Combining all output
.PHONY: all view
all: clean force Ryan_Larson-Graphics_Application.pdf

view: Ryan_Larson-Graphics_Application.pdf
	epdfview $<

Ryan_Larson-Graphics_Application.pdf: build/resume.pdf build/cover.pdf build/examples.pdf
	pdftk $^ cat output $@

# 2. Building individual PDFs
.PHONY: builds
BUILD=build
RESUME=$(BUILD)/resume.pdf
COVER=$(BUILD)/cover.pdf
EXAMPLES=$(BUILD)/examples.pdf
builds: $RESUME $COVER $EXAMPLES
$(EXAMPLES): $(EGIMAGES)
$(BUILD)/%.pdf: src/%.tex src/%/*.tex src/awesome-cv.cls src/shared.tex
	cd src && xelatex -no-file-line-error $(notdir $<)
	mv $(basename $<).pdf $@
	rm $(basename $<).{log,fls,synctex.gz,fdb_landmark} -f

# 1. Building output graphics
EG1=src/images/CarSentoGram.png
EG2=src/images/di.png
EG3=src/images/politweets.png
EGIMAGES: $EG1 $EG2 $EG3
MONTAGE=montage -border 15 -background white -bordercolor white -geometry +0+0
$(EG2): src/images/di-*.png
	$(MONTAGE) -tile 2x $^ $@
$(EG3): src/images/collusion-network-on-twitter.png  src/images/repeated-fake-news.png
	$(MONTAGE) -tile 2x $^ $@


# 0. Clean command
.PHONY: clean force view
clean :
	find . -type f -name '*.aux' -exec rm {} +
	find . -type f -name '*.out' -exec rm {} +
	find . -type f -name '*.log' -exec rm {} +
	find . -type f -name '*.fls' -exec rm {} +
	find . -type f -name '*.synctex.gz' -exec rm {} +
	rm -f build/*
force:
	touch src/*.tex src/images/{di-*,CarSentoGram,politweets}.png


# OLD
src/images/college.png: src/images/cropped_0.png src/images/cropped_1.png src/images/cropped_2.png
	convert $^ +append $@
build/resume.txt: src/resume.tex
	# Convert resume tex to unified text file
	cd src && detex $(notdir $<) > ../$@
	# Remove empty (non char) lines from text file
	sed -i '/^[[:space:]]*$$/d;s/[[:space:]]*$$//' $@
	# Remove cruft from latex preamble
	tail -n +7 $@ > $@.tmp && mv $@.tmp $@
