TODO:  Confirm year zero implementation
add date link into standard
confirm that 200BCE dates can be used in death dates

TODO:  recorded in "Graves Art Sales"?


## Additional Testing
* [ ] Rebuild acquisition tests
* [ ] Date String Tests

* [ ] Reclassify acquisitions using CRM events: purchase/custody/ownership/creation.
* [ ] Document the EDTF pattern
* [ ] Find AAT type for "place associated with"
* [ ] add in the ownership period and the other date relationships to the model
* [ ] make sure the model covers all possible fields


## High Level Components
* [ ] JSON -> CIDOC-CRM
* [ ] JSON -> Text
* [ ] JSON -> HTML
* [ ] Extract out Date logic
* [ ] Extract Acquisitions
* [ ] Microthesaurii
* [ ] MicroAuthority
* [ ] Determine what parts of the base system are still needed.

## Features 
* [ ] Handle Open Dates
* [ ] Look into EDTF intervals?
* [ ] clause/location either order
* [ ] see if I can remove date specificity


## Todos for Acquisition Methods
* [ ] Integrate into m_p codebase
* [ ] Finish extracting self-documentation into class
* [ ] Think about `suffix`/`prefix`
* [ ] Think about types
* [ ] Think about OWL
* [ ] Think about OWL import?
* [ ] Move documentation into subfolder
* [ ] HTML instead of markdown?


----


## Done

* [x] Convert Date into EDTF
* [x] Convert Date into String
* [x] Convert Date into earliest/latest pair (through EDTF?)
* [x] Token
* [X] No Dates
* [X] String/Token replacement in unparsable things
* [x] Footnotes and Citation marks
* [x] Get raw string (maybe through the offsets of the direct transfers?)
* [X] Test for No Date in full parser
* [x] Add citations
* [x] Add footnotes
* [X] should decade precision be 199u-uu-uu, not 199x?
* [X] "purchase": {"string": "$11M"}
* [X] write up a AST for something with everything filled out
* [X] write a test for it!
