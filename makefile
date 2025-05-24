MACHINE ?= $$(hostname -s)

collect:
	@zsh ./collect_files.zsh

edit:
	@$(EDITOR) $(MACHINE)/_list

enroll:
	@echo "enrolling $(MACHINE)..."
	@mkdir -p $(MACHINE)
	@touch $(MACHINE)/_list
	@echo "~/.zsh-machine" >> $(MACHINE)/_list

show:
	@tree --noreport -a $(MACHINE)

