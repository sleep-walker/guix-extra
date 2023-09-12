(define-module (sw packages linux-own)
;;  #:use-module (guix guix)
  #:use-module (guix packages)
  #:use-module (gnu packages linux)
  #:use-module ((gnu packages) #:select (search-auxiliary-file))
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
(define-public linux-doom
  (corrupt-linux linux-libre-6.4
		 #:name "linux-doom"
		 #:defconfig "/Devel/git/guix-extra/sw/packages/aux-files/kernel-doom-sw8.config"))

