(in-package :primarvarden-tests)

(in-root-suite)
(defsuite* other-tests)

(defun do-fill-person-add-form ()
 (do-type "name=förnamn" (random-string (list (get-universal-time))))
 (do-type "name=efternamn" (random-string (list (get-universal-time)))))

(deftest ads-a-person ()
  (with-new-or-existing-selenium-session 
    (do-open-and-wait *site-url*)
    (do-click-and-wait "link=Personer")
    (is-request-path "/primarvarden/employees")
    (do-click-and-wait "css=input[value=Add]")
    (do-fill-person-add-form)
    (do-click-and-wait "name=submit")
    (is-flash-message-shown "Added employee.")))
