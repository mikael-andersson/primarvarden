(in-package :primarvarden-tests)

(defun md5-hex (string)
  "Calculates the md5 sum of the string STRING and returns it as a hex string."
  (string-downcase  
    (with-output-to-string (s)
      (loop for code across (md5:md5sum-sequence (coerce string 'simple-string))
            do (format s "~2,'0x" code)))))

(defmacro repeat-until-success (&body body)
  `(let ((ret)) 
     (loop do 
           (and 
             (handler-case  
               (progn 
                 (setf ret 
                       (progn ,@body)) 
                 t) 
               (execution-error () nil)) 
             (return)))
     ret))

(defun random-string (tokens &key (length 5))
  (let* ((to (+ (random (- 32 length)) length))
         (from (- to length)))
    (string-downcase  (subseq  (md5-hex (format nil "~{~A~^ ~}" tokens)) from to))))

(defun create-random-email ()
  (format nil "t~A@spamavert.com" (random-string (list (get-universal-time)))))

(defun link-to-check-email (email)
  (cl-ppcre:register-groups-bind (email-name)
    ("(.*)@" email)
    (format nil "http://spamavert.com/mail/~A" email-name)))

(defun retrieve-email-body-from-spamavert (email)
  (repeat-until-success
    (open-last-mail-page email) 
    (do-click "id=btnOriginal") 
    (do-wait-for-page-to-load 5000) 
    (do-select-frame "index=0") 
    (do-wait-for-page-to-load 1000)
    (prog1 
      (do-get-text "css=pre")
      (do-select-frame "relative=parent"))))

(defmacro with-new-or-existing-selenium-session (&body body)
  `(progn  
     (if *in-selenium-session* 
       (progn 
         ,@body) 
       (with-selenium-session 
         (*selenium-session* *selenium-browser* *site-url*)
         (do-open-and-wait *site-url*)
         (let ((*in-selenium-session* t))
           (do-set-timeout 1000)
           ,@body 
           #+l(unwind-protect
             )) 
         (do-test-complete)))))

(defun extract-password-from-register-email-body (register-email-body)
  (cl-ppcre:register-groups-bind (password)
    ("\"([^\"]+)\"" register-email-body)
    password))

(defun is-flash-message-shown (message)
  (is (string-equal message (do-get-text "css=ul.messages"))))

(defun is-some-flash-message-shown ()
  (is (> (length (do-get-text "css=ul.messages")) 0)))

(defun is-request-path (path)
  (is (string= path (do-get-eval "selenium.browserbot.getCurrentWindow().location.pathname"))))

(defun open-last-mail-page (email)
  (repeat-until-success
    (do-open (link-to-check-email email)) 
    (do-wait-for-page-to-load 1000) 
    (do-click-and-wait "css=.maillist li:first") 
    (do-wait-for-page-to-load 1000)))

(defun do-open-and-wait (url)
  (do-open url)
  (do-wait-for-page-to-load 5000))

(defun in-root-suite ()
  (hu.dwim.stefil::in-root-suite))
