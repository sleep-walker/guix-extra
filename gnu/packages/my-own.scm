;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Tomáš Čech <sleep_walker@suse.cz>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages my-own)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages conkeror)
  #:use-module (gnu packages suckless)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages readline)
  #:use-module (guix build-system cmake)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  )

(define-public my-conkeror
  (package
   (inherit conkeror)
   (name "my-conkeror")
   (source
    (origin
     (inherit (package-source conkeror))
     (patches (list (search-patch "/Devel/git/guix-extra/gnu/packages/patches/ctrl-click.patch")))))))

(define-public my-dwm
  (package
   (inherit dwm)
   (name "my-dwm")
   (version "6.0sw")
   (source
    (origin
     (inherit (package-source dwm))
     (patches (list (search-patch "dwm-6.0-systray.diff")
		    (search-patch "dwm-r1615-selfrestart.diff")
		    (search-patch "dwm-6.0-sw.patch")))))))

(define-public sdcv
  (package
   (name "sdcv")
   (version "0.5.0-beta4")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "mirror://sourceforge/project/sdcv/sdcv/sdcv-"
			 version "-Source.tar.bz2"))
     (sha256
      (base32 "1b9v91al2c1499q6yx6q8jggid0714444mfj6myqgz3nvqjyrrqr"))))
   (build-system cmake-build-system)
   (native-inputs
    `(("pkg-config" ,pkg-config)))
   (inputs
    `(("glib" ,glib)
      ("gettext" ,gnu-gettext)
      ("readline" ,readline)
      ("zlib" ,zlib)))
   (arguments
    `(#:tests? #f ; no tests implemented
      #:phases
      ;; this is known workaround for missing lang files
      (alist-cons-after 'build 'build-lang
			(lambda _ (zero? (system* "make" "lang")))
			%standard-phases)))
   (home-page "http://sdcv.sourceforge.net/")
   (synopsis "Command line variant of StarDict")
   (description
    "Sdcv is command line dictionary utility, which supports StarDict dictinary
format.")
   (license license:gpl2+)))
