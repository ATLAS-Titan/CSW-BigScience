#-  GNU Makefile

#-  Makefile ~~
#
#   This contains live instructions to typeset a PDF.
#
#   This isn't as fancy as my "usual" Makefiles, which are full of macros and
#   happiness, but there is a much greater level of urgency here than usual.
#
#                                                   ~~ last updated 18 Jan 2019

SHELL       :=  sh
ECHO        :=  echo

define alert
    printf '\033[1;31mError: %s\n\033[1;0m' $(strip $(1)) >&2
endef

define contingent
    $(shell \
        contingent() {                                                      \
            for each in $$@; do                                             \
                command -v $${each} >/dev/null 2>&1                     ;   \
                if [ $$? -eq 0 ]; then                                      \
                    command -v $${each}                                 ;   \
                    return $$?                                          ;   \
                fi                                                      ;   \
            done                                                        ;   \
            printf 'echo "\033[1;31m(%s)\033[1;0m"' '$(firstword $(1))' ;   \
            return 1                                                    ;   \
        }                                                               ;   \
        contingent $(1)                                                     \
    )
endef

PROJ_ROOT   :=  $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
PROJECT     :=  draft
SUBMISSION  :=  $(PROJ_ROOT)/$(PROJECT).pdf

BIBTEX      :=  $(call contingent, bibtex)
GREP        :=  $(call contingent, grep)
LATEX       :=  $(call contingent, pdflatex latex) -no-shell-escape
OPEN        :=  $(call contingent, acroread gnome-open open)
RM          :=  $(call contingent, rm) -rf

greplog     =   ( $(GREP) -c $(1) "$(PROJ_ROOT)/$(PROJECT).log" > /dev/null )

.PHONY: all clean clobber distclean reset run

all: run

clean: reset

clobber: clean
	@   $(RM) $(wildcard *.aux *.bbl *.blg *.dvi *.log *.out)

distclean: clobber
	@   $(RM) $(SUBMISSION)

open: $(SUBMISSION)
	@   $(OPEN) $^

reset:
	@   $(call contingent, clear)

run: $(SUBMISSION)
	@   $(OPEN) $(SUBMISSION)

###

$(SUBMISSION): $(wildcard $(PROJ_ROOT)/*.bib $(PROJ_ROOT)/*.tex)
	@   cd $(PROJ_ROOT)                                             ;   \
            $(LATEX) -draftmode -jobname $(PROJECT) main                ;   \
            while $(call greplog, "Rerun to"); do                           \
                $(BIBTEX) $(PROJECT)                                    ;   \
                $(LATEX) -draftmode -jobname $(PROJECT) main            ;   \
            done                                                        ;   \
            $(LATEX) -jobname $(PROJECT) main

###

%:
	@   $(call alert, "No target '$@' is available.")

#-  vim:set syntax=make:
