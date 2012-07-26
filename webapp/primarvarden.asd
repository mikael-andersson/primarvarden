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
    :depends-on (:weblocks :metatilities)
    :components ((:file "package")
                 (:module conf
		  :components ((:file "stores"))
                  :depends-on ("package"))
                 (:file "primarvarden"
		  :depends-on ("conf" "package"))
		 (:module src
		  :components ((:file "layout"
				      :depends-on (model "views" "widgets"))
			       (:file "snippets")
                   (:file "util")
                   (:file "views" :depends-on ("model"))
;			       (:file "sandbox"
;				      :depends-on (model))
			       (:file "init-session"
				      :depends-on ("layout" "snippets"))
;				      :depends-on ("layout" "snippets" "sandbox"))
;			       (:module views
;					:components ((:module types
;							      :components ((:file "hsn")))))
;						     :depends-on (view formview dataview)))
;					:depends-on ("weblocks" "dependencies" utils))
			       (:module model
                    :depends-on ("util")
					:components ((:file "unit"
							    :depends-on ("company"))
						     (:file "project")
						     (:file "company")
						     (:file "address")
						     (:file "person"
							    :depends-on ("address"))
						     (:file "employee"
							    :depends-on ("person"))
                             (:file "project-person" 
                                :depends-on ("employee" "project"))))
                   (:module widgets 
                    :depends-on ("util" "model")
                    :components ((:file "employees-grid"))))
		  :depends-on ("primarvarden" conf package))))
