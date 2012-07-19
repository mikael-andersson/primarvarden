(in-package :primarvarden)

(defwidget employees-grid (gridedit)
  ())

(defun/cc employees-grid-add-persons-to-projects-flow (obj items)
  (let ((item-name (humanize-name (dataseq-data-class obj))))
    (when (dataseq-selection-empty-p items)
      (flash-message (dataseq-flash obj)
                     (format nil "Please select ~A to add."
                             (pluralize (string-downcase item-name))))
      (mark-dirty obj)
      (return-from employees-grid-add-persons-to-projects-flow))

    (let ((initial-items-count (dataseq-data-count obj))
          (choice-result (do-choice 
                           "Please choose project to add persons to"
                           (append 
                             (get-projects-titles)
                             '(:cancel)))))
      (if (eq :cancel choice-result)
        (return-from employees-grid-add-persons-to-projects-flow))
      (let ((projects (find-by-values 'project :titel choice-result)))

        (ecase (car items)
          ;; (:all ...)
          (:none (connect-projects-persons projects (loop for i in (cdr items) append (find-by-values 'employee :id i)))))

        (mark-dirty obj :propagate t)
        (flash-message (dataseq-flash obj) (format nil "Successfully added ~d persons to project ~s." (length (cdr items)) (project-title (car projects))))))))

(defmethod dataedit-update-operations :around ((obj employees-grid) &key
				   (delete-fn #'dataedit-delete-items-flow)
				   (add-fn #'dataedit-add-items-flow))
  (call-next-method)
  (pushnew (cons 'add-person-to-project #'employees-grid-add-persons-to-projects-flow)
           (dataseq-item-ops obj)
           :key #'car))

(let ((session-key  'employee-form-view-showed-repeat-message))
  (defmethod dataedit-create-new-item-widget :around ((grid employees-grid))
    (delete-webapp-session-value 'employee-form-view-showed-repeat-message)
    (call-next-method))

  ;;; Form View
  (defview employee-form-view (:type form :inherit-from 'person-form-view
                               :satisfies (lambda (&rest args)
                                            (let ((employees-with-same-name-and-last-name 
                                                    (find-by-values 'employee 
                                                                    :förnamn (getf args :förnamn) 
                                                                    :efternamn (getf args :efternamn))))
                                              (if (and (not (webapp-session-value session-key)) employees-with-same-name-and-last-name)
                                                (progn 
                                                  (setf (webapp-session-value session-key) t)
                                                  (values nil "There is already employee with same name. Press submit button again to force adding."))
                                                (progn 
                                                  (delete-webapp-session-value session-key)
                                                  t))))
                               :caption "Person")
           (FoUU-roll :present-as (radio :choices '(:kontaktperson :projektledare :verksamhetschef))
                         :parse-as keyword)))

; This update needed to fix bug
; source: weblocks-20120305-git/src/views/types/presentations/radio.lisp
;
(defmethod render-view-field ((field form-view-field) (view form-view)
			      widget (presentation radio-presentation) value obj
			      &rest args &key validation-errors field-info &allow-other-keys)
  (let* ((attribute-slot-name (if field-info
                                (attributize-view-field-name field-info)
                                (attributize-name (view-field-slot-name field))))
	 (validation-error (assoc attribute-slot-name (remove-if (lambda (item) (null (car item))) validation-errors)
				  :test #'string-equal
				  :key #'view-field-slot-name))
	 (field-class (concatenate 'string attribute-slot-name
				   (when validation-error " item-not-validated"))))
    (with-html
      (:li :class field-class
	   (:span :class "label"
		  (:span :class "slot-name"
			 (:span :class "extra"
				(str (view-field-label field)) ":&nbsp;"
                                (when (form-view-field-required-p field)
                                  (htm (:em :class "required-slot" "(required)&nbsp;"))))))
	   (apply #'render-view-field-value
		  value presentation
		  field view widget obj
		  args)
	   (when validation-error
	     (htm (:p :class "validation-error"
		      (:em
		       (:span :class "validation-error-heading" "Error:&nbsp;")
		       (str (format nil "~A" (cdr validation-error)))))))))))