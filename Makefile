PYTHON	   := python -m json.tool
XSLTPROC   := xsltproc
TAR		   := tar -cf - 
GZIP       := gzip -9
STYLESHEET := cadf-xml2json.xslt
OBJS	   := geolocation_ex1.json geolocation_ex2.json geolocation_ex3.json  \
			  geolocation_ex4.json geolocation_ex5.json annotations-only.json \
		      event.json no-annotations.json annotations-only.json
TGZ	       := cadf-xslt.tar.gz

default: $(OBJS)

%.json: %.xml
	$(XSLTPROC) --output $@ $(STYLESHEET) $<

.PHONY: test
test: $(OBJS)
	for i in $(OBJS); do echo $$i && $(PYTHON) < $$i; done

.PHONY: dist
dist: $(TGZ)
$(TGZ): Makefile $(OBJS) $(wildcard *.xml) $(wildcard *.xslt)
	$(TAR) $^ | $(GZIP) > $(TGZ)

.PHONY: clean
clean:
	-rm -rf *.json $(TGZ)
