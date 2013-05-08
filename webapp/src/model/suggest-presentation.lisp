
(in-package :primarvarden)

(export '(*use-suggest* suggest
	  suggest-presentation suggest-presentation-use-suggest-p
	  suggest-presentation-input-id
	  suggest-presentation-choices-id suggest-parser))

(defparameter *use-suggest* t
  "If true, suggest snippet will be used to render suggest types in
forms. A simple dropdown will be used otherwise.")

(defclass suggest-presentation (input-presentation)
  ((use-suggest-p :initform *use-suggest*
		  :initarg :use-suggest-p
		  :accessor suggest-presentation-use-suggest-p
		  :documentation "If set to true, suggest snippet will
		  be used as suggest input control. Otherwise,
		  dropdown will be used.")
   (input-id :initform (gensym)
	     :initarg :input-id
	     :accessor suggest-presentation-input-id
	     :documentation "An input ID passed to suggest or
	     dropdown.")
   (choices-id :initform (gensym)
	       :initarg :choices-id
	       :accessor suggest-presentation-choices-id
	       :documentation "A choices ID passed to suggest.")
   (function :accessor get-function
	     :initarg :function)))

(defmethod render-view-field-value (value (presentation suggest-presentation) 
				    (field form-view-field) (view form-view) widget obj
				    &rest args &key intermediate-values field-info &allow-other-keys)
  (declare (ignore args))
  (multiple-value-bind (intermediate-value intermediate-value-p)
      (form-field-intermediate-value field intermediate-values)
    (let ((selections (funcall (get-function presentation)))
	  (default-value (if intermediate-value-p
			     intermediate-value
			     (append (ensure-list value)
				     (ensure-list
				      (find value (funcall (get-function presentation)) :test #'equalp)))))

	  (welcome-name "Suggest"))
      (if (suggest-presentation-use-suggest-p presentation)
	  (render-suggest (if field-info
                            (attributize-view-field-name field-info)
                            (attributize-name(view-field-slot-name field)))
	  		  selections
	  		  :default-value default-value
	  		  :welcome-name welcome-name
	  		  :max-length (input-presentation-max-length presentation)
	  		  :input-id (suggest-presentation-input-id presentation)
	  		  :choices-id (suggest-presentation-choices-id presentation))
	  (render-dropdown (attributize-view-field-name field-info) selections
			   :selected-value default-value
			   :welcome-name welcome-name
			   :id (suggest-presentation-input-id presentation))))))

(defclass suggest-parser (parser)
  ((error-message :initform "a valid name"))
  (:documentation "A parser designed to parse strings into names."))

;; NOT SURE IF THIS REALLY IS NEEDED
;; (defmethod parse-view-field-value ((parser suggest-parser) value obj
;; 				   (view form-view) (field form-view-field) &rest args)
;;   (declare (ignore args))
;;   (let* ((value (string-trim +whitespace-characters+ value))
;; 	 (break "check-name")
;;          (db-item (first-by 'employee 
;;                             (lambda (item)
;;                               (string= (person-name item) value)))))
;;     (when db-item 
;;       (values t t db-item))))

(defmethod dependencies append ((self suggest-presentation))
  (when (suggest-presentation-use-suggest-p self)
    (list (make-local-dependency :stylesheet "suggest"))))
