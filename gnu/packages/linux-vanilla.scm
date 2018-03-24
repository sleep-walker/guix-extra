(define-module (gnu packages linux-vanilla)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages elf)
  #:use-module (guix build-system trivial)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (srfi srfi-1)
  #:export (initrd-x1-sw1))

;; (define-public linux-vanilla
;;   (package
;;     (inherit linux-libre)
;;     (name "linux-vanilla")
;;     (version "4.0")
;;     (source (origin
;; 	      (method url-fetch)
;; 	      (uri (string-append "https://www.kernel.org/pub/linux/kernel/v4.x/linux-" version ".tar.xz"))
;; 	      (sha256
;; 	       (base32
;; 		"14argl6ywkggdvgiycfx4jl2d7290f631ly59wfggj4vjx27sbqg"))))))

(define-public x1-kernel-config
  "/Devel/git/guix-extra/gnu/packages/kernel-x1-sw1.config")

(define-public vulture-kernel-config
  "/Devel/git/guix-extra/gnu/packages/kernel-vulture-sw1.config")


(define-public linux-vanilla
  (package
    (inherit linux-libre)
    (version "4.15.12")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://cdn.kernel.org/pub/linux/kernel/v4.x/"
                    "linux-" version ".tar.xz"))
              (sha256
               (base32
                "0j7l907m51y05cd1sqf3sn7vx4n6c07kn7q0ndnyg6wqb7h667h3"))))))

(define-public linux-x1-sw1
  (package
    (inherit linux-vanilla)
    (name "linux-x1-sw1")
    (native-inputs
     `(("kconfig" ,x1-kernel-config)
       ("libelf" ,libelf)
       ,@(alist-delete "kconfig"
                       (package-native-inputs linux-vanilla))))))


(define-public linux-vulture-sw1
  (package
    (inherit linux-vanilla)
    (name "linux-vulture-sw1")
    (native-inputs
     `(("kconfig" ,vulture-kernel-config)
       ("libelf" ,libelf)
       ,@(alist-delete "kconfig"
                       (package-native-inputs linux-vanilla))))))


(define-public linux-vanilla-headers
  (package
    (inherit linux-libre-headers)
    (name "linux-vanilla-headers")
    (version (package-version linux-vanilla))
    (source (origin (inherit (package-source linux-vanilla))))))

(define-public linux-firmware
  (let ((commit "7344ec9e1df9e27d105ed48d2db99e22370236de"))
    (package
      (name "linux-firmware")
      (version (string-append "2018.02.22-" (string-take commit 7)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                        (url (string-append
                              "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git"))
                        (commit commit)))
                (sha256
                 (base32
                  "1gg0iblrrz22zmj5yq82nbnk1b7zs0rdzi2f8c0pi77gqp5dz0hj"))))
      (build-system trivial-build-system)
      (arguments
       `(#:modules ((guix build utils))
         #:builder
         (begin
           (use-modules (guix build utils))

           (let* ((source   (assoc-ref %build-inputs "source"))
                  (out      (assoc-ref %outputs "out"))
                  (firmware (string-append out "/lib/firmware")))
             (mkdir-p firmware)
             (copy-recursively source firmware)))))
      (home-page "https://github.com/wkennington/linux-firmware")
      (synopsis "Linux firmware")
      (description "Linux firmware.")
      (license #f))))

(define-public linux-firmware-initrd-x1-sw1
  (package
    (name "linux-firmware-initrd-x1-sw1")
    (version (package-version linux-firmware))
    (home-page "https://sleep-walker.cz")
    (synopsis "FW files required for initrd")
    (build-system trivial-build-system)
    (native-inputs
     `(("linux-firmware" ,linux-firmware)))
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let* ((out (assoc-ref %outputs "out"))
                (fwtgt (string-append out "/lib/firmware/"))
                (fw (string-append (assoc-ref %build-inputs "linux-firmware") "/lib/firmware/")))
           (mkdir-p (string-append out "/bin"))
           (mkdir-p (string-append out "/sbin"))
           (mkdir-p fwtgt)
           (for-each (lambda (file)
                       (let ((src (string-append fw file))
                             (dst (string-append fwtgt file)))
                         (mkdir-p (dirname dst))
                         (copy-file src dst)))
                       '("i915/kbl_dmc_ver1_01.bin" "iwlwifi-8265-34.ucode"))
           #t))))
    (source #f)
    (license #f)
    (description "Initrd firmware files.")))
      ;; (gexp->derivation
      ;;                                     "initrd-fw-x1-sw1"
      ;;                                     #~(call-with-output-fle
      ;;                                        #$output
      ;;                                        (begin
      ;;                                          (mkdir #$output)
      ;;                                          (chdir #$output)
      ;;                                          (copy-file
      ;;                                           (string-append
      ;;                                            #$linux-firmware
      ;;                                            "/lib/firmware/iwlwifi-8265-34.ucode")
      ;;                                           (string-append #$output
      ;;                                                          "/lib/firmware/iwlwifi-8265-34.ucode")))))

(define* (initrd-x1-sw1 file-systems
                        #:key
                        (linux linux-x1-sw1)
                        (mapped-devices '())
                        qemu-networking?
                        volatile-root?
                        (virtio? #t)
                        (extra-modules '())
                        (on-error 'debug))

  (define helper-packages
    (file-system-packages file-systems #:volatile-root? volatile-root?))

  (raw-initrd file-systems
              #:linux linux-x1-sw1
              #:linux-modules '()
              #:mapped-devices mapped-devices
              #:helper-packages helper-packages
              #:qemu-networking? qemu-networking?
              #:volatile-root? volatile-root?
              #:on-error on-error))
