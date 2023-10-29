(define-module (sw packages linux-own)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages linux)
  #:use-module (srfi srfi-1)
  #:use-module (nongnu packages linux))

(define sw-linux linux-6.5)
(define-public doom-config (local-file "aux-files/kernel-doom-sw9.config"))
(define-public linux-doom
  (package
   (inherit sw-linux)
   (name "linux-doom")
   (native-inputs
    `(("kconfig" ,doom-config)
      ("zstd" ,zstd)
      ,@(alist-delete "kconfig"
                      (package-native-inputs sw-linux))))
   (arguments
    (substitute-keyword-arguments (package-arguments sw-linux)
      ((#:phases phases)
       #~(modify-phases #$phases
		       (replace 'configure
			 (lambda* (#:key native-inputs inputs #:allow-other-keys)
			   (copy-file #$doom-config ".config")
			   (display "Copied own config")
			   (invoke "make" "oldconfig")))))))))
