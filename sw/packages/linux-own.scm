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

;; (define (config-linux package-linux config-path)
;;   (package
;;     (inherit package-linux)
;;     (native-inputs
;;      `(("kernel-config" ,(local-file config-path))
;;      ,@(alist-delete "kernel-config"
;;                      (package-native-inputs package-linux))))))

;;(define-public linux-doom (config-linux linux-6.4 "kernel-doom-sw8.config"))

;; (define-public linux-doom
;;   (corrupt-linux linux-libre-6.4 #:defconfig "kernel-doom-sw8.config"))
(define (linux-url version)
  "Return a URL for Linux VERSION."
  (string-append "mirror://kernel.org"
                       "/linux/kernel/v" (version-major version) ".x"
                       "/linux-" version ".tar.xz"))

(define* (sw-corrupt-linux freedo
                        #:key
                        (name "linux")
                        (configs '())
			(configuration-file #f)
                        (defconfig #f))

  ;; TODO: This very directly depends on guix internals.
  ;; Throw it all out when we manage kernel hashes.
  (define gexp-inputs (@@ (guix gexp) gexp-inputs))

  (define extract-gexp-inputs
    (compose gexp-inputs force origin-uri))

  (define (find-source-hash sources url)
    (let ((versioned-origin
           (find (lambda (source)
                   (let ((uri (origin-uri source)))
                     (and (string? uri) (string=? uri url)))) sources)))
      (if versioned-origin
          (origin-hash versioned-origin)
          #f)))

  (let* ((version (package-version freedo))
         (url (linux-url version))
         (pristine-source (package-source freedo))
         (inputs (map gexp-input-thing (extract-gexp-inputs pristine-source)))
         (sources (filter origin? inputs))
         (hash (find-source-hash sources url)))
    (package
      (inherit
       (customize-linux
        #:name name
        #:source (origin
                   (method url-fetch)
                   (uri url)
                   (hash hash))
        #:configs configs
        #:configuration-file configuration-file
        #:defconfig defconfig))
      (version version)
      (home-page "https://www.kernel.org/")
      (synopsis "Linux kernel with nonfree binary blobs included")
      (description
       "The unmodified Linux kernel, including nonfree blobs, for running Guix System
on hardware which requires nonfree software to function."))))


(define-public linux-doom
  (sw-corrupt-linux linux-libre-6.4
		 #:name "linux-doom"
		 #:configuration-file "/Devel/git/guix-extra/sw/packages/aux-files/kernel-doom-sw8.config"))

