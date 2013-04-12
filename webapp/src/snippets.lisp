
(in-package :primarvarden)

;;; Header
(defun render-header (&rest args)
  (declare (ignore args))
  "This function renders the page header."
  (with-html
    (:div :class "header"
	  (with-extra-tags))))

;;; Footer
(defmethod render-page-body :after ((app primarvarden) rendered-html)
  (with-html
      (:div :class "footer"
	    #|(:p :id "system-info"
		"Running on "
		(str (concatenate 'string (server-type) " " (server-version)))
		" (" (str (concatenate 'string (lisp-implementation-type) " "
				      (lisp-implementation-version))) ")")|#
	    (:p :id "description" :style "color:white;"
		"Based on the Common Lisp web framework "
		(:a :href "http://weblocks.viridian-project.de/" "Weblocks") "and the demo app weblocks-demo.")
	    (:p :id "contact-info" :style "color:white;"
		"Developed by " (:a :href "mailto:mikael@fripost.org" "Mikael Andersson") "and "
		(:a :href "mailto:olexiy.z@gmail.com" "Olexiy Zamkoviy"))
	    (:br)
	    
	    ;;(:img :src "/pub/images/footer/valid-xhtml11.png" :alt "This site has valid XHTML 1.1.")
	    ;;(:img :src "/pub/images/footer/valid-css.png" :alt "This site has valid CSS.")
	    )))

