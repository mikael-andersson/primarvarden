
(in-package :primarvarden)

(defun initial-page (k)
  "Initial page is so simple we can just define a function to render
it and use it as a widget. Since it will be used in a continuation
flow, it accepts K - the continuation parameter."
  (with-html
    (:div :style "text-align: center; font-size:1.4em; margin-top: 4em;"
	  (:p "This demo application was coded in" (:br)
	      (:a :href "http://weblocks.viridian-project.de/" "Weblocks")
	      " - a Lisp web framework." (:br) (:br)
	      "The source of the demo contains" (:br)
	      "200 lines of Lisp" (:br)
	      "and" (:br)
	      "0 line of HTML or Javascript." (:br))
	  (render-link (lambda (&rest args)
			 (declare (ignore args))
			 (answer k))
		       "Start Demo"
		       :ajaxp nil)
	  (:p "(You can also try it with Javascript disabled.)"))))

(defun make-main-page ()
  "Lays out the main page. It consists of a FLASH widget for showing
initial message, and a NAVIGATION widget with panes that hold
employees page, companies page and projects page."
  (make-instance 'widget :children
		 (list
		  ;; (make-instance 'flash :messages
		  ;; 		 (list (make-widget "Welcome to weblocks demo - a
                  ;;                                   technology demonstration for a
                  ;;                                   continuations-based web
                  ;;                                   framework written in Common
                  ;;                                   Lisp.")))
		  (make-navigation "Main Menu"
				   (list "Personer" (make-employees-page) "employees")
;;				   (list "Ägare" (make-companies-page) "companies")
				   (list "Projekt" (make-projects-page) "projects")
				   (list "Enheter" (make-units-page) "units")))))

(defun make-employees-page ()
  "Lays out the widgets for the employees page. It consists of a
   single GRIDEDIT widget."
  (let* ((name)
         (widget  
           (make-instance 'employees-grid
                          :name 'employees-grid
                          :drilldown-type :view
                          :on-query (lambda (widget order limit &key countp) 
                                      (let ((items (if (zerop (length name))
                                                     (all-of 'employee :order-by order :range limit)
                                                     (flet ((similar (item)
                                                              (search (string-downcase name) (string-downcase (person-name item)))))
                                                       (find-by 'employee #'similar :order-by order :range limit)))))
                                        (if countp
                                          (length items)
                                          items)))
                          :data-class 'employee
                          :view 'employee-table-view
                          :item-data-view 'employee-data-view
                          :item-form-view 'employee-form-view)))
    (setf (pagination-items-per-page (dataseq-pagination-widget widget)) 5)
    (make-instance 'widget :children
                   (list
                     (make-quickform (defview nil (:type form :persistp nil :buttons '((:submit . "Search") (:cancel . "Clear search")) :caption "Search by name")
                                              (name :present-as input))
                                     :answerp nil
                                     :on-success (lambda (form object)
                                                   (setf name (slot-value object 'name))
                                                   (mark-dirty widget))
                                     :on-cancel (lambda (form)
                                                  (setf (slot-value (dataform-data form) 'name) nil)
                                                  (setf name nil)
                                                  (mark-dirty form)
                                                  (mark-dirty widget)))
                     widget))))

;; (defun make-companies-page ()
;;   "Lays out the widgets for the companies page. It consists of a
;; single GRIDEDIT widget."
;;   (make-instance 'widget :children
;; 		 (list
;; 		  (make-instance 'gridedit
;; 				 :name 'companies-grid
;; 				 :data-class 'company
;; 				 :view 'company-table-view
;; 				 :item-form-view 'company-form-view))))

(defun make-projects-page ()
  "Lays out the widgets for the projects page. It consists of a
single GRIDEDIT widget."
  (make-instance 'widget :children
		 (list
		  (make-instance 'gridedit
				 :name 'projects-grid
				 :data-class 'project
				 :view 'project-table-view
				 :item-form-view 'project-form-view))))

(defun make-units-page ()
  "Lays out the widgets for the units page. It consists of a
single GRIDEDIT widget."
  (make-instance 'widget :children
		 (list
		  (make-instance 'gridedit
				 :name 'units-grid
				 :data-class 'unit
				 :view 'unit-table-view
				 :item-form-view 'unit-form-view))))
