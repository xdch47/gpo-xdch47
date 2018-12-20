#!/usr/bin/env tclsh

#----------------------------------------------------------------------
# prologue for nagelfar
#----------------------------------------------------------------------
set debug 0
package require Tcl 8.5

# This makes it possible to customize where files are installed
set dbDir      @GENTOO_PORTAGE_EPREFIX@/usr/lib/nagelfar
set docDir     @GENTOO_PORTAGE_EPREFIX@/usr/share/doc/nagelfar-@GENTOO_PORTAGE_PV@

set version {Version @GENTOO_PORTAGE_PV@}

