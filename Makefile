PY?=python3
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py
#THEME=/usr/lib/python3/dist-packages/pelican/themes/simple
#THEME=../pelican-themes/mnmlist
THEME=../pelican-themes/tuxlite_tbs

OUTPUT_RETENTION = [".git"]

GITHUB_PAGES_BRANCH=master

PAGESDIR=$(INPUTDIR)/pages
DATE := $(shell date +'%Y-%m-%d %H:%M:%S')
SLUG := $(shell echo '${NAME}' | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z)
EXT ?= md

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make newpost NAME="name-of-post"    create a new post                  '
	@echo '   make editpost NAME="name-of-post"   edit a post                        '
	@echo '   make newpage NAME="name-of-page"    create a new page                  '
	@echo '   make editpage NAME="name-of-page"   edit a page                        '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          serve and regenerate together      '
	@echo '   make ssh_upload                     upload the web site via SSH        '
	@echo '   make rsync_upload                   upload the web site via rsync+ssh  '
	@echo '   make github                         upload the web site via gh-pages   '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) -t ${THEME} $(PELICANOPTS)

clean:
	#[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)
	$(PELICAN) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -d

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) -t ${THEME} $(PELICANOPTS)

serve:
ifdef PORT
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) -t ${THEME} $(PELICANOPTS) -p $(PORT)
else
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) -t ${THEME} $(PELICANOPTS)
endif

serve-global:
ifdef SERVER
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) -b $(SERVER)
else
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) -b 0.0.0.0
endif


devserver:
ifdef PORT
	$(PELICAN) --listen --relative-urls $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) -t ${THEME} $(PELICANOPTS) -p $(PORT)
else
	$(PELICAN) --listen --relative-urls $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) -t ${THEME} $(PELICANOPTS)
endif

publish:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) -t ${THEME} $(PELICANOPTS)

github: publish
	ghp-import -m "Generate Pelican site" -b $(GITHUB_PAGES_BRANCH) $(OUTPUTDIR)
	git push origin $(GITHUB_PAGES_BRANCH)

newpost:
ifdef NAME
	echo "Title: $(NAME)" >  $(INPUTDIR)/$(SLUG).$(EXT)
	echo "Slug: $(SLUG)" >> $(INPUTDIR)/$(SLUG).$(EXT)
	echo "Date: $(DATE)" >> $(INPUTDIR)/$(SLUG).$(EXT)
	echo ""              >> $(INPUTDIR)/$(SLUG).$(EXT)
	echo ""              >> $(INPUTDIR)/$(SLUG).$(EXT)
	${EDITOR} ${INPUTDIR}/${SLUG}.${EXT} 
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make newpost NAME='"'"'Post Name'"'"
endif

editpost:
ifdef NAME
	${EDITOR} ${INPUTDIR}/${SLUG}.${EXT} 
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make editpost NAME='"'"'Post Name'"'"
endif

newpage:
ifdef NAME
	echo "Title: $(NAME)" >  $(PAGESDIR)/$(SLUG).$(EXT)
	echo "Slug: $(SLUG)" >> $(PAGESDIR)/$(SLUG).$(EXT)
	echo ""              >> $(PAGESDIR)/$(SLUG).$(EXT)
	echo ""              >> $(PAGESDIR)/$(SLUG).$(EXT)
	${EDITOR} ${PAGESDIR}/${SLUG}.$(EXT)
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make newpage NAME='"'"'Page Name'"'"
endif

editpage:
ifdef NAME
	${EDITOR} ${PAGESDIR}/${SLUG}.$(EXT)
else
	@echo 'Variable NAME is not defined.'
	@echo 'Do make editpage NAME='"'"'Page Name'"'"
endif


.PHONY: html help clean regenerate serve serve-global devserver stopserver publish github