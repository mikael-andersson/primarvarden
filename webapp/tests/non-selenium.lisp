(in-package :primarvarden-tests)

(in-root-suite)
(defsuite* non-selenium-tests)

(deftest types ()
  (is (equal "test" "test")) 
  (is (equal 1 1))) 
