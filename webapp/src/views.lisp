(in-package :primarvarden)

;;; Data View
(defview employee-data-view (:type data :inherit-from 'person-data-view
                             :caption "Person")
         (projects-involved 
           :present-as html 
           :reader (lambda (person)
                     (let ((person-project-connections  (find-by-values 'project-person :person person)))
                       (when person-project-connections
                         (format nil "~{<b>~A</b> as <b>~A</b><br/>~}" 
                                 (loop for project-person in person-project-connections append
                                       (list (project-title (project-person-project project-person))
                                             (project-role-pretty-presentation 
                                               (project-person-role 
                                                 project-person)))))))))
         (emails)
         (phone-numbers))

(defun project-persons-involved-reader (project)
  (concatenate 
                       'string 
                       (let ((project-persons  (project-employees project)))
                         (if project-persons
                           (format nil "~{<b>~A</b> as <b>~A</b><br/>~}" 
                                   (loop for i in project-persons append 
                                         (list (person-name i) 
                                               (project-role-pretty-presentation 
                                                 (project-person-role 
                                                   (first (find-by-values 
                                                            'project-person
                                                            :project project 
                                                            :person i)))))))
                           "<span class=\"value missing\">Nobody</span><br/>"))
                       "<br/>"))

(defview project-data-view (:type data :inherit-from '(:scaffold project)
				  :caption "Projekt")
  (id :hidep t)
  (persons-involved
           :present-as html 
           :reader #'project-persons-involved-reader))
;;; Form View
(defview project-form-view (:type form :inherit-from '(:scaffold project)
				  :caption "Projekt")
  (id :hidep t)
  (persons-involved 
           :present-as html 
           :reader #'project-persons-involved-reader))

