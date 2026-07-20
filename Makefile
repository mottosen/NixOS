# Pass SYS=<profile> to skip the prompt, e.g. `make update-switch SYS=laptop`
define rebuild
	@if [ -n "$(SYS)" ]; then \
		SYS_CHOICE="$(SYS)"; \
	else \
		printf "What system? "; \
		read SYS_CHOICE; \
	fi; \
	echo "System choice: $$SYS_CHOICE"; \
	sudo nixos-rebuild $(1) --flake ".#$$SYS_CHOICE"
endef

.PHONY: update-flake update-build update-boot update-switch

update-flake:
	nix flake update

update-build:
	$(call rebuild,build)

update-boot:
	$(call rebuild,boot)

update-switch:
	$(call rebuild,switch)
