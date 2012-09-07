(in-package :primarvarden)

;;; Data View
(defview employee-data-view (:type data :inherit-from 'person-data-view
				   :caption "Person")
  FoUU-roll 
  (projects-involved 
    :present-as html 
    :reader (lambda (person)
              (let ((person-projects  (employee-projects person)))
                (when person-projects
                  (format nil "~{~A<br/>~}" (mapcar #'project-title person-projects))))))
  (emails)
  (phone-numbers))

;;; Form View
(defview project-form-view (:type form :inherit-from '(:scaffold project)
				  :caption "Projekt")
  (id :hidep t)
  (persons-involved 
           :present-as html 
           :reader (lambda (project)
                     (concatenate 
                       'string 
                       (let ((project-persons  (project-employees project)))
                         (if project-persons
                           (format nil "~{~A<br/>~}" (mapcar #'person-name project-persons))
                           "<span class=\"value missing\">Nobody</span><br/>"))
                       "<br/>"
                       (capture-weblocks-output 
                         (render-link 
                           (make-action (lambda (&rest args)
                                          (weblocks:redirect "/primarvarden/employees")))
                           "Add some persons to project"))))))

