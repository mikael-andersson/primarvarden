(in-package :primarvarden)

;;; Project-person connection
(defclass project-person ()
  ((id)
   (project :accessor project-person-project :initarg :project :type project)
   (person :accessor project-person-person :initarg :person :type employee)
   (role :accessor project-person-role :initarg :role)))

(defun connect-projects-persons (projects persons role)
  (loop for project in projects do 
        (loop for person in persons do 
              (unless (find-by-values 'project-person :project project :person person)
                (persist-object *default-store* (make-instance 'project-person :project project :person person :role role))))))

(defmethod employee-projects ((person employee))
  (mapcar #'project-person-project (find-by-values 'project-person :person person)))

(defmethod project-employees ((project project))
  (mapcar #'project-person-person (find-by-values 'project-person :project project)))

