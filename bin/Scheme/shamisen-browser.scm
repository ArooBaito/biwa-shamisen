(define scheme-interpreter (js-new "BiwaScheme.Interpreter"))

(define socket (js-new "WebSocket" "ws://localhost:8090"))
(define ping-timer #f)

(define (send-socket message . args)
  (.. socket `(send ,message)))

(define (on-connected event . args)
  (send-socket "\"Connected to browser successfully\"")
  (console-log "Connected to Shamisen successfully")
  (set! ping-timer (set-timer! (lambda ()
		  (send-socket "ping")) 5)))

(define (on-message event . args)
  (define message (.. event `data))
  (unless (string=? message "ping")
    (.. scheme-interpreter `(evaluate ,message))))

(define (on-close event . args)
  (clear-timer! ping-timer)
  (define was-clean? (.. event `wasClean))
  (if was-clean?
      (console-log "Connection with Shamisen closed")
      (console-log "Lost connection to Shamisen")))

(define (on-error error . args)
  (define error-message (.. error `message))
  (console-log "Shamisen server encountered an error:")
  (console-log error-message))

(js-set! socket "onopen" (js-closure on-connected))
(js-set! socket "onmessage" (js-closure on-message))
(js-set! socket "onclose" (js-closure on-close))
(js-set! socket "on-error" (js-closure on-close))
