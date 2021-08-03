(define http (.. `console `globals `http))
(define ws (.. `console `globals `ws))

;;(define port (list-ref (command-line) 2))
(define port 8090)

(define websocket-server (js-new "console.globals.ws.Server"
				 (alist->js-obj
				  '(("noServer" . #t)))))

(define should-evaluate? #f)

(define (buffer->string buffer)
  (.. buffer `(toString)))

(define (evaluate-scheme scheme-str)
  (.. `console `globals `biwa `(run ,scheme-str)))

(define (print-buffer buffer)
  (print (buffer->string buffer)))

(define websocket-list '())

(define (broadcast-clients message)
  (for-each (lambda (websocket)
	      (.. websocket `(send ,message))) websocket-list))

(define (on-connect websocket . args)
  (define (add-to-client-list)
    (set! websocket-list
	  (append websocket-list (list websocket))))

  (add-to-client-list)
  
  (define (close-connection)
    (.. websocket `(close 1000 "Web-socket closed.")))

  (define (send-client message)
    (.. websocket `(send ,message)))

  (define (on-received message . args)
    (unless (string=? (buffer->string message) "ping")
      (print-buffer message)
      (unless (string=? (buffer->string message) "")
	(broadcast-clients (buffer->string message)))))

  (set-timer! (lambda () (send-client "ping")) 5)
  (.. websocket `(on "message" ,(js-closure on-received))))


(define (accept request response . args)
  
  (define (ignore)
    (.. response `(end)))
  
  (define (upgrade-exists?)
    (.. request `headers `upgrade))

  (define (is-websocket?)
    (string=?
     (.. request `headers `upgrade `(toLowerCase))
     "websocket"))

  (define (connect . args)
    (.. websocket-server `(handleUpgrade ,request
					 ,(.. request `socket)
					 ,(.. (js-eval "Buffer") `(alloc 0))
					 ,(js-closure on-connect))))
  
  (cond
   ((not (upgrade-exists?)) (ignore))
   ((not (is-websocket?))   (ignore))
   (#t                      (connect))))

(define (has-module-parent?)
  (js-undefined? (.. `console `globals `module `parent)))

(define (listen-on port)
  (.. http `(createServer ,(js-closure accept)) `(listen ,port)))

(define (export-as-library)
  (js-set! (.. `console `globals `exports "accept" (js-closure accept))))

(if (not (has-module-parent?))
    (listen-on port)
    (export-as-library))

(print (string-append
	"Shamisen server started on "
	(number->string port)))

