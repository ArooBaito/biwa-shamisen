(define http (.. `console `globals `http))
(define ws (.. `console `globals `ws))

;;(define port (list-ref (command-line) 2))
(define port 8090)
(define scheme-string (list-ref (command-line) 2))

(define left-parens 0)
(define right-parens 0)

(define (parens-equal?)
  (= left-parens right-parens))

(define (reset-parens)
  (set! left-parens 0)
  (set! right-parens 0))

(define (count-left-parens message)
  (for-each (lambda (char)
	      (when (char=? char #\()
		(set! left-parens
		      (+ 1 left-parens))))
	    (string->list message)))

(define (count-right-parens message)
  (for-each (lambda (char)
	      (when (char=? char #\))
		(set! right-parens
		      (+ 1 right-parens))))
	    (string->list message)))

(define input "")

(define (reset-input)
  (set! input ""))

(define (append-input message)
  (set! input
	(string-append input message)))

(define (get-websocket port)
  (define new-websocket
    (string-append
     "new console.globals.ws(\"ws://localhost:"
     (number->string port)
     "\")"))
  (js-eval new-websocket))

(define interface-properties (js-obj))
(js-set! interface-properties "input" (.. `process `stdin))
(js-set! interface-properties "output" (.. `process `stdout))

(define interface
  (.. `console `globals `readline
      `(createInterface ,interface-properties)))

(define (buffer->string buffer)
  (.. buffer `(toString)))

(define (print-buffer buffer)
  (print (buffer->string buffer)))

(define websocket-client (get-websocket port))

(define (send-websocket message)
  (.. websocket-client `(send ,message)))

(define (on-connect . args)

  (define (process-message message)
    (append-input message)
    (count-left-parens input)
    (count-right-parens input)
    (when (parens-equal?)
	(send-websocket input)
	(reset-input))
    (reset-parens))
  
  (set-timer! (lambda () (send-websocket "ping")) 5)
  
  (send-websocket "\"Emacs connected successfully\"")
  
  (define (on-message message . args)
    (unless (string=? (buffer->string message) "ping")
      (print-buffer message)))
  
  (.. interface `(on "line" ,(js-closure process-message)))
  (.. websocket-client `(on "message" ,(js-closure on-message))))


(.. websocket-client `(on "open" ,(js-closure on-connect)))
