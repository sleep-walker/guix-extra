;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Tomáš Čech <sleep_walker@suse.cz>
;;;
;;; This file is NOT part of GNU Guix.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages my-own)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages enlightenment)
  #:use-module (gnu packages kerberos)
  #:use-module (gnu packages suckless)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages tls)
  #:use-module (guix build-system cmake)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1)
  )

(define-public my-dwm
  (package
   (inherit dwm)
   (name "my-dwm")
   (source
    (origin
     (inherit (package-source dwm))
     (patches (list (search-patch "dwm-6.0-systray.diff")
		    (search-patch "dwm-r1615-selfrestart.diff")
		    (search-patch "dwm-6.0-sw.patch")))))))

(define-public my-curl
  (package
    (inherit curl)
    (name "my-curl")
    (inputs
     `(("mit-krb5" ,mit-krb5)
       ,@(alist-delete "gss" (package-inputs curl))))
    (arguments
     (substitute-keyword-arguments (package-arguments curl)
       ((#:configure-flags flags)
        `(map (lambda (flag)
                (if (string=? flag "--with-gssapi")
                    (string-append "--with-gssapi=" (assoc-ref %build-inputs "mit-krb5"))
                      flag))
                ,flags))))
    ))

(define-public my-icecat
  (package
    (inherit icecat)
    (name "my-icecat")
    (arguments
     (substitute-keyword-arguments (package-arguments icecat)
                                   ((#:configure-flags flags)
       ;; `((use-modules (srfi srfi-1))
       ;;   (filter (lambda (flag)
       ;;            (not (any (lambda (str)
       ;;                        (string=? flag str))
       ;;                      '("--disable-eme"
       ;;                        "--with-distribution-id=org.gnu"
       ;;                        "--disable-tests"
       ;;                        "--disable-updater"
       ;;                        "--disable-crashreporter"
       ;;                        "--disable-maintenance-service"))))
       ;;           ,flags:)))))
        `(map (lambda (flag)
                (if (string=? flag "--disable-eme")
                    "--enable-eme=widevine"
                    flag))
                ,flags))))
    ))


(define-public my-p7zip
  (package
   (inherit p7zip)
   (name "my-p7zip")
   (source
    (origin
      (inherit (package-source p7zip))
      (snippet #f)))))

(define-public my-terminology
  (package
   (inherit terminology)
   (name "my-terminology")
   (source
    (origin
      (inherit (package-source terminology))
      (snippet #f)))))

(define-public sdcv
  (package
   (name "sdcv")
   (version "0.5.2")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://github.com/Dushistov/" name "/archive/v" version ".tar.gz"))
     (sha256
      (base32 "1xy48ghd458g00cd8p19cq1rpw4lyaxj06phknldaj07984dq27c"))))
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
