SRC=dumper.ml common.ml regexp_pcre.ml regexp.ml ast_cocci.ml ograph_simple.ml \
 ograph_extended.ml flag.ml parse_printf.ml ast0_cocci.ml visitor_ast.ml \
 token_annot.ml flag_parsing_c.ml parsing_stat.ml \
 includes.ml \
 token_c.ml ast_c.ml control_flow_c.ml \
 visitor_c.ml lib_parsing_c.ml \
 control_flow_c_build.ml \
 pretty_print_c.ml \
 semantic_c.ml lexer_parser.ml parser_c.ml lexer_c.ml \
 parse_string_c.ml token_helpers.ml token_views_c.ml \
 cpp_token_c.ml  \
 parsing_hacks.ml \
 cpp_analysis_c.ml \
 unparse_cocci.ml unparse_c.ml unparse_hrule.ml  \
 parsing_recovery_c.ml parsing_consistency_c.ml \
 danger.ml parse_c.ml type_c.ml \
 cpp_ast_c.ml \
 type_annoter_c.ml comment_annotater_c.ml \
 compare_c.ml \
 test_parsing_c.ml

OCAMLFLAGS=-package pcre,num,str,unix

OCAMLFIND=ocamlfind
OCAMLC=$(OCAMLFIND) ocamlc
OCAMLOPT=$(OCAMLFIND) ocamlopt
OCAMLLEX=$(OCAMLFIND) ocamllex
OCAMLYACC=$(OCAMLFIND) ocamlyacc
OCAMLDEP=$(OCAMLFIND) ocamldep

.PHONY: all
all: parsing_c.cma parsing_c.cmxa

.PHONY: clean
clean:
	rm -f $(SRC:.ml=.cmi) $(SRC:.ml=.cmo) $(SRC:.ml=.cmx) $(SRC:.ml=.o)
	rm -f lexer_c.mll parser_c.mly
	rm -f parsing_c.a parsing_c.cma parsing_c.cmxa
	rm -f .depend

.PHONY: install
install:
	$(OCAMLFIND) install coccinelle-c-parser \
	  $(wildcard $(SRC:.ml=.mli) $(SRC:.ml=.cmi)) \
	  $(SRC:.ml=.cmx) $(SRC:.ml=.cmo) \
	  parsing_c.cma parsing_c.cmxa \
	  META

parsing_c.cma: $(SRC:.ml=.cmo)
	$(OCAMLC) -a -o $@ $^

parsing_c.cmxa: $(SRC:.ml=.cmx)
	$(OCAMLOPT) -a -o $@ $^

%.ml: %.mll
	$(OCAMLLEX) -o $@ $<

%.ml: %.mly
	$(OCAMLYACC) -o $@ $<

%.cmi: %.mli
	$(OCAMLOPT) $(OCAMLFLAGS) -c -o $@ $<

%.cmo: %.ml $(wildcard %.cmi)
	$(OCAMLC) $(OCAMLFLAGS) -c -o $@ $<

%.cmx: %.ml $(wildcard %.cmi)
	$(OCAMLOPT) $(OCAMLFLAGS) -c -o $@ $<

.depend: $(SRC) $(wildcard $(SRC:.ml=.mli))
	$(OCAMLDEP) $(SRC) $(wildcard $(SRC:.ml=.mli)) >.depend

ifneq ($MAKECMDGOALS),clean)
include .depend
endif
