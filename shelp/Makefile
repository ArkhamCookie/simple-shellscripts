INSTALL_DIR=~/.local/bin/shellscripts

all:
	@echo "Please run 'make install'"

install:
	@echo ""
	mkdir -p $(INSTALL_DIR)
	cp ./bin/shelp.sh $(INSTALL_DIR)/shelp
	@echo ""
	@echo "Please add $(INSTALL_DIR) to your path"
	@echo ''
	@echo 'USAGE:'
	@echo '------'
	@echo 'f[ilter] <error-number> <file>'
	@echo 'p[rint] <file>'

clean:
	@echo "Removing all scripts..."
	rm -rf $(INSTALL_DIR)
	@echo "Done!"
