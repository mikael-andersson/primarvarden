(in-package :primarvarden)

(defun render-checkboxes (name selections &key id (class "checkbox") selected-values)
  (dolist (val selections)
    (let ((checked-p (if (find (cdr val) selected-values :test #'equal) "checked" nil))
          (label (if (consp val) (car val) val))
          (value (if (consp val) (cdr val) val)))
    (with-html
      (:div (:input :name (attributize-name name) :type "checkbox" :id id :class class
	      :checked checked-p :value value (str (humanize-name label))))))))
