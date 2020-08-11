# CONFIGS
BUILD=build
IMAGES=src/images
FINAL=Ryan_Larson_Graphics_Reporter.pdf

LATEX=xelatex -shell-escape -interaction=nonstopmode -no-file-line-error
LATEXMK=latexmk -pdf -xelatex -pvc
MONTAGE=montage -border 15 -background white -bordercolor white -geometry +0+0
INKSCAPE=inkscape -C -z
# figures/%.pdf: figures/%.svg
#     inkscape -C -z --file=$< --export-pdf=$@


# 3. Combining all output
.PHONY: all view builds
all: clean force $(FINAL)
view: $(FINAL)
	epdfview $<

# watch:
# 	$(LATEX) $(FINAL)

$(FINAL): build/resume.pdf build/cover.pdf build/examples.pdf
	pdftk $^ cat output $@

# 2. Building individual PDFs
builds: $RESUME $COVER $EXAMPLES

RESUME=$(BUILD)/resume.pdf
COVER=$(BUILD)/cover.pdf

$(BUILD)/examples.pdf: $(EGIMAGES)
# $(EXAMPLES):

$(BUILD)/%.pdf: src/%.tex src/%/*.tex src/awesome-cv.cls src/shared.tex
	cd src && $(LATEX) $(notdir $<)
	mv $(basename $<).pdf $@
	@rm $(basename $<).{log,fls,synctex.gz,fdb_landmark} -f

# 1. Building output graphics
EGIMAGES	 : $EXAMPLE_ONE $EXAMPLE_TWO $EXAMPLE_THR
EXAMPLE_ONE=$(IMAGES)/CarSentoGram.png
EXAMPLE_TWO=$(IMAGES)/di.png
EXAMPLE_THR=$(IMAGES)/politweets.png

$(EXAMPLE_TWO): $(IMAGES)/di-*.png
	$(MONTAGE) -tile 2x $^ $@

$(EXAMPLE_THR): $(IMAGES)/collusion-network-on-twitter.png  $(IMAGES)/repeated-fake-news.png
	$(MONTAGE) -tile 1x2 $^ $@

$(IMAGES)/college.png: $(IMAGES)/cropped_0.png $(IMAGES)/cropped_1.png $(IMAGES)/cropped_2.png
	$(MONTAGE) -tile 1x3 $^ $@


# 0. Clean command
.PHONY: clean force view
clean :
	@find . -type f -name '*.aux' -exec rm {} +
	@find . -type f -name '*.out' -exec rm {} +
	@find . -type f -name '*.log' -exec rm {} +
	@find . -type f -name '*.fls' -exec rm {} +
	@find . -type f -name '*.synctex.gz' -exec rm {} +
	@rm -f build/*

force:
	touch src/*.tex src/images/{di-*,CarSentoGram,politweets}.png

build/resume.txt: src/resume.tex
	cd src && detex $(notdir $<) > ../$@
	sed -i '/^[[:space:]]*$$/d;s/[[:space:]]*$$//' $@
	tail -n +9 $@ > $@.tmp && mv $@.tmp $@