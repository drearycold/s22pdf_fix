import fitz
doc = fitz.open("new.pdf")

xref, gen = doc._getPageXref(2)
print(xref)
print(doc._getXrefString(xref))
cxref = doc[2]._getContents()
print(cxref)
stream = doc._getXrefStream(cxref[0])
print(stream)

for page in doc:
    for xref in page._getContents():
        stream = doc._getXrefStream(xref).replace(b'/Fm0 Do\n', b'')
        # print(stream)
        doc._updateStream(xref, stream)

doc.save("removed.pdf", garbage=1, deflate=1)

xref, gen = doc._getPageXref(2)
print(xref)
print(doc._getXrefString(xref))
cxref = doc[2]._getContents()
print(cxref)
stream = doc._getXrefStream(cxref[0])
print(stream)

