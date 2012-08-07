(in-package :primarvarden-tests) 

(defun do-all-tests ()
  (format t "Non-selenium tests")
  (non-selenium-tests)
  (format t "Other tests")
  (other-tests))

