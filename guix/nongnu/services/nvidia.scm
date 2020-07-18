(define-module (nongnu services nvidia)
  #:use-module (gnu packages linux)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services shepherd)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (ice-9 match)
  #:use-module (nongnu packages nvidia)
  #:export (nvidia-insmod-service-type))

(define (nvidia-insmod-shepherd-service config)
  (list (shepherd-service
         (provision '(nvidia-insmod))
         (requirement '())
         ;; run the nvidia-insmod script
         (start #~(lambda _
                    (and
                     (zero? (system* (string-append #$nvidia-driver "/bin/nvidia-insmod"))))))
         (one-shot? #t)
         (auto-start? #t)
         (respawn? #f))))

(define nvidia-insmod-service-type
  (service-type
   (name 'nvidia-insmod-name)
   (extensions
    (list (service-extension shepherd-root-service-type nvidia-insmod-shepherd-service)))
   (default-value '())))
