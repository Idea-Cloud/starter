########################################################################################################################
#
# INSTALL
#
########################################################################################################################

install:
	@make make-in-node MAKE_RULE=_install

_install:
	@# Fix dependency with git url
	@#sed -i '35s|github:eligrey/FileSaver.js#1.3.8|2.0.2|' node_modules/jspdf/package.json
	@npm install
