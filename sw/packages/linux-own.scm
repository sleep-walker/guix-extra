(define-module (sw packages linux-own)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages linux)
  #:use-module (srfi srfi-1)
  #:use-module (nongnu packages linux))

(define-public linux-doom
  (package
   (inherit linux-6.5)
   (name "linux-doom")
   (native-inputs
    `(("kconfig" ,(local-file "aux-files/kernel-doom-sw8.config"))
      ,@(alist-delete "kconfig"
                      (package-native-inputs linux-6.5))))))

