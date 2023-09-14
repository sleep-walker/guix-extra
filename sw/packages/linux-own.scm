(define-module (sw packages linux-own)
;;  #:use-module (guix guix)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (gnu packages linux)
  #:use-module (rnrs lists)  
;;  #:use-module ((gnu packages) #:select (search-path))
  #:use-module (nongnu packages linux))

;; ;; (define (config-linux package-linux config-path)
;; ;;   (package
;; ;;     (inherit package-linux)
;; ;;     (native-inputs
;; ;;      `(("kernel-config" ,(local-file config-path))
;; ;;      ,@(alist-delete "kernel-config"
;; ;;                      (package-native-inputs package-linux))))))

;; ;;(define-public linux-doom (config-linux linux-6.4 "kernel-doom-sw8.config"))

;; ;; (define-public linux-doom
;; ;;   (corrupt-linux linux-libre-6.4 #:defconfig "kernel-doom-sw8.config"))
;; (define (linux-url version)
;;   "Return a URL for Linux VERSION."
;;   (string-append "mirror://kernel.org"
;;                        "/linux/kernel/v" (version-major version) ".x"
;;                        "/linux-" version ".tar.xz"))

;; (define* (sw-corrupt-linux freedo
;;                         #:key
;;                         (name "linux")
;;                         (configs '())
;; 			(configuration-file #f)
;;                         (defconfig #f))

;;   ;; TODO: This very directly depends on guix internals.
;;   ;; Throw it all out when we manage kernel hashes.
;;   (define gexp-inputs (@@ (guix gexp) gexp-inputs))

;;   (define extract-gexp-inputs
;;     (compose gexp-inputs force origin-uri))

;;   (define (find-source-hash sources url)
;;     (let ((versioned-origin
;;            (find (lambda (source)
;;                    (let ((uri (origin-uri source)))
;;                      (and (string? uri) (string=? uri url)))) sources)))
;;       (if versioned-origin
;;           (origin-hash versioned-origin)
;;           #f)))

;;   (let* ((version (package-version freedo))
;;          (url (linux-url version))
;;          (pristine-source (package-source freedo))
;;          (inputs (map gexp-input-thing (extract-gexp-inputs pristine-source)))
;;          (sources (filter origin? inputs))
;;          (hash (find-source-hash sources url)))
;;     (package
;;       (inherit
;;        (customize-linux
;;         #:name name
;;         #:source (origin
;;                    (method url-fetch)
;;                    (uri url)
;;                    (hash hash))
;;         #:configs configs
;;         #:configuration-file configuration-file
;;         #:defconfig defconfig))
;;       (version version)
;;       (home-page "https://www.kernel.org/")
;;       (synopsis "Linux kernel with nonfree binary blobs included")
;;       (description
;;        "The unmodified Linux kernel, including nonfree blobs, for running Guix System
;; on hardware which requires nonfree software to function."))))

;; (define (%upstream-linux-source version hash)
;;   (origin
;;     (method url-fetch)
;;     (uri (string-append "mirror://kernel.org"
;;                         "/linux/kernel/v" (version-major version) ".x/"
;;                         "linux-" version ".tar.xz"))
;;     (sha256 hash)))

;; (define sw-linux-version "6.4.15")
;; (define sw-linux-revision "sw8")
;; (define sw-linux-hash "0z6f7lnwbw2y7wwfr253d6gg4kz0l62s71pj266hb9c0dj15xl0r")


;; (define sw-linux-sources
;;   (%upstream-linux-source
;;    sw-kernel-version
;;    "1phlx375ln5pslw5vjqm029cdv6pzf4ang10xlrf90x5sb4fgy93"))

;; (define-public linux-doom
;;   (make-linux-libre* sw-kernel-version
;;                      ""  ; no revision
;; 		     sw-linux-sources
;; 		       ;linux-libre-6.4-source
;;                      '("x86_64-linux")  ; supported-systems
;; 		     #:extra-version "sw8"
;;                      #:configuration-file kernel-config))

;; ;; (define-public linux-doom
;; ;;   (sw-corrupt-linux linux-libre-6.4
;; ;; 		 #:name "linux-doom"
;; ;; ;;		 #:configuration-file "/Devel/git/guix-extra/sw/packages/aux-files/kernel-doom-sw8.config"
;; ;; 		 ))


;; (define (sw-linux-url version)
;;   "Return a URL for Linux VERSION."
;;   (string-append "mirror://kernel.org"
;;                        "/linux/kernel/v" (version-major version) ".x"
;;                        "/linux-" version ".tar.xz"))


;; (define-public sw-linux-source
;;   (make-linux-xanmod-source
;;    sw-linux-version
;;    sw-linux-revision
;;    (base32 sw-linux-hash)))


;; (define-public sw-linux
;;   (make-linux-xanmod sw-linux-version
;;                      sw-linux-revision
;;                      sw-linux-source))


(define-public linux-doom
  (package
    (inherit linux-6.4)
    (native-inputs
     `(("kconfig" ,(local-file "aux-files/kernel-doom-sw8.config"))
      ,@(alist-delete "kconfig"
                      (package-native-inputs linux-6.4))))))
