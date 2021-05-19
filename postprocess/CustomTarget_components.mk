# vim: set noet sw=4 ts=4:
# -*- Mode: makefile-gmake; tab-width: 4; indent-tabs-mode: t -*-
#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

$(eval $(call gb_CustomTarget_CustomTarget,postprocess/components))

# Creating these files just works with the info from a full build.
ifeq (,$(gb_PARTIAL_BUILD))

postprocess_WORKDIR := $(call gb_CustomTarget_get_workdir,postprocess)

$(call gb_CustomTarget_get_target,postprocess/components): \
    $(postprocess_WORKDIR)/services_componentfiles.list \

$(postprocess_WORKDIR)/services_componentfiles.list: \
    | $(postprocess_WORKDIR)/.dir
	$(call gb_Output_announce,$(subst $(BUILDDIR)/,,$@),$(true),GEN,2)
	TEMPFILE=$(call var2file,$(shell $(gb_MKTEMP)),1,$(sort $(gb_ComponentTarget__ALLCOMPONENTS))) && \
	    mv $$TEMPFILE $@

$(postprocess_WORKDIR)/services_constructors.list: \
    $(SRCDIR)/solenv/bin/constructors.py \
    $(postprocess_WORKDIR)/services_componentfiles.list \
    | $(postprocess_WORKDIR)/.dir
	$(call gb_Output_announce,$(subst $(BUILDDIR)/,,$@),$(true),GEN,2)
	TEMPFILE=$(shell $(gb_MKTEMP)) && \
	    $(call gb_Helper_abbreviate_dirs,$(call gb_ExternalExecutable_get_command,python) $^) > $$TEMPFILE && \
	    $(call gb_Helper_replace_if_different_and_touch,$${TEMPFILE},$@)

endif

# vim: set noet sw=4:
