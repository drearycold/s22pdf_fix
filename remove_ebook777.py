import sys
import fitz
import fitz.utils

doc = fitz.open("new.pdf")

if False:
    xref, gen = doc._getPageXref(1)
    print(xref)
    print(doc._getXrefString(xref))
    cxref = doc[1]._getContents()
    print(cxref)
    for c in cxref:
        stream = doc._getXrefStream(c)
        print(stream)
# doc[2]._setContents(cxref[2])

# sys.exit(0)

for page in doc:
    annot = page.firstAnnot
    while annot:
        print(("ANNOT", annot))
        annot = annot.next()

    cxref = page._getContents()
    length = len(cxref)
    print(length)

    if length != 6:
        continue

    page._setContents(cxref[2])
    
    print(("page._getLinkXrefs()", page._getLinkXrefs()))

    link = page.firstLink
    while link:
        ld = fitz.utils.getLinkDict(link)
        print(("LINK", link, link.parent))
        print(ld)
        link = link.next
    for link in page.getLinks():
        print(("page.getLinks", link))
        if link['kind' ] == 2 and link['uri'] == 'http://www.ebook777.com':
            #print(("page.getLinks", link))
            page.deleteLink(link)
            #page.setLinks([])

    for k, v in page._annot_refs.items():
        print((k, v))

    # for xref in page._getContents():
    #    stream = doc._getXrefStream(xref)
    #    print(stream)
        # doc._updateStream(xref, stream

if False:
    xref, gen = doc._getPageXref(2)
    print(xref)
    print(doc._getXrefString(xref))
    cxref = doc[2]._getContents()
    print(cxref)
    stream = doc._getXrefStream(cxref[0])
    print(stream)

# sys.exit(0)

doc.save("removed.pdf", garbage=1, deflate=1, clean=0)

