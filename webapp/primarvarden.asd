;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(defpackage #:primarvarden-asd
  (:use :cl :asdf))

(in-package :primarvarden-asd)

(defsystem primarvarden
    :name "primarvarden"
    :version "0.1"
    :author "Slava Akhmechet"
    :licence "Public Domain"
    :description "primarvarden"
    :depends-on (:weblocks :metatilities :weblocks-filtering-widget)
    :components ((:file "package")
                 (:module conf
			  :components ((:file "stores"))
			  :depends-on ("package"))
                 (:file "primarvarden"
			:depends-on ("conf" "package"))
		 (:module src
			  :components ((:file "layout"
					      :depends-on (model "widgets"))
				       (:file "render-checkboxes-update")
				       (:file "snippets")
				       (:file "util")
				       (:file "init-session"
					      :depends-on ("layout" "snippets"))
				       (:module model
						:depends-on ("util")
						:components ((:file "unit"
								    :depends-on ("company" "suggest-presentation"))
							     (:file "project-persons-views"
								    :depends-on ("project"))
							     (:file "suggest-presentation"
								    :depends-on ("employee"))
							     (:file "project")
							     (:file "company")
							     (:file "address")
							     (:file "employee"
								    :depends-on ("address"))
							     (:file "project-person" 
								    :depends-on ("employee" "project"))))
				       (:module widgets 
						:depends-on ("util" "model")
						:components ((:file "employees-grid"))))
			  :depends-on ("primarvarden" conf package))))

(defpackage #:primarvarden-tests-asd
  (:use :cl :asdf))

(in-package :primarvarden-tests-asd)

(defsystem primarvarden-tests
     :name "primarvarden-tests"
     :version "0.0.1"
     :maintainer ""
     :author ""
     :licence ""
     :description "primarvarden-tests"
     :depends-on (:primarvarden :hu.dwim.stefil :selenium)
     :components (
         (:file "primarvarden-tests")
         (:module tests :depends-on ("primarvarden-tests")
          :components 
          ((:file "util" :depends-on ("parameters"))
           (:file "parameters")
           (:file "all-tests" :depends-on ("util" "non-selenium"))
           (:file "non-selenium" :depends-on ("util"))
           (:file "other" :depends-on ("util"))))))

