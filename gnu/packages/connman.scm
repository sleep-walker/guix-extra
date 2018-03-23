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

(define-module (gnu packages connman)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
;  #:use-module (guix build-system cmake)
  #:use-module (gnu packages)  
  #:use-module (gnu packages admin)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages python)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages vpn)
)

(define-public connman
  (package
   (name "connman")
   (version "1.30")
   (source (origin
	    (method url-fetch)
	    (uri (string-append "https://www.kernel.org/pub/linux/network/connman/connman-" version ".tar.xz"))
	    (sha256
	     (base32 "14d9zxikc4qjjask6r72bdzr81wz0nsvk7r6wza7xhn9mi5lcpjw"))))
   (build-system gnu-build-system)
   (native-inputs
    `(("pkg-config" ,pkg-config)))
   (inputs
    `(("openconnect" ,openconnect)
      ("dbus" ,dbus)
      ("glib" ,glib)
      ("gnutls" ,gnutls)
      ("iptables" ,iptables)
      ("openvpn" ,openvpn)
      ("polkit" ,polkit)
      ("python" ,python)
      ("readline" ,readline)
      ("vpnc" ,vpnc)
      ("wpa-supplicant" ,wpa-supplicant)
      ))
   (arguments
    '(#:configure-flags (list "--enable-client" "--enable-shared"
			      "--disable-gtk-doc" "--disable-debug"
			      "--enable-pie" "--enable-threads"
			      "--enable-hh2serial-gps" "--enable-openconnect"
			      ; PPP not available for now
			      ;  "--enable-pptp" "--enable-l2tp"
			      "--enable-vpnc"
			      "--enable-openvpn"
			      "--disable-iwmx" "--enable-iospm"
			      "--enable-tist" "--enable-session-policy"
			      "--enable-test" "--enable-nmcompat"
			      "--enable-polkit" "--enable-loopback"
			      "--enable-ethernet" "--enable-wifi"
			      "--enable-bluetooth" "--enable-ofono"
			      "--enable-dundee" "--enable-pacrunner"
			      "--enable-wispr" "--enable-client"
			      "--enable-tools" "--enable-datafiles"
			      (string-append "--with-dbusconfdir="
					     (assoc-ref %outputs "out")
					     "/etc"))
      #:phases (alist-cons-after
		'install 'install-manually
		(lambda _
		(let* ((out (assoc-ref %outputs "out")))
		       (mkdir-p (string-append out "/bin"))
		       (copy-file "client/connmanctl" (string-append out "/bin/connmanctl"))))
		%standard-phases)
      ))
   (home-page "https://01.org/connman")
   (synopsis "Connection manager not only for mobile devices")
   (description
    "ConnMan is modern and modular daemon managing connections to
network using various technologies suitable for use in embedded
devices but very well usable on desktops or notebooks as well.")
   (license license:gpl2)))
