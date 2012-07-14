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
  "Should be used to update operations the widget supports.

'delete-fn' - a function to be called when delete action is invoked.
'add-fn' - a function to be called when add action is invoked."
  (call-next-method)
  (pushnew (cons 'add-person-to-project #'employees-grid-add-persons-to-projects-flow)
           (dataseq-item-ops obj)
           :key #'car))
