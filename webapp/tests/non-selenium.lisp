(in-package :primarvarden-tests)

(in-root-suite)
(defsuite* non-selenium-tests)

(deftest types ()
  (is (equal "test" "test")) 
  (is (equal 1 1))) 

(defun make-employee ()
  (primarvarden::persist-object primarvarden::*default-store* (make-instance 'primarvarden::employee)))

(defun make-project ()
  (primarvarden::persist-object primarvarden::*default-store* (make-instance 'primarvarden::project)))

(defun make-employee-project-connection (employee project)
  (primarvarden::persist-object primarvarden::*default-store* (make-instance 'primarvarden::project-person :project project :person employee)))

(deftest deletes-employee-correctly ()
  (let* ((employee (make-employee))
         (employee-id (primarvarden::object-id employee))
         (project (make-project))
         (employee-project-connection (make-employee-project-connection employee project))
         (employee-project-connection-id (primarvarden::object-id employee-project-connection)))
    (primarvarden::delete-persistent-object-by-id primarvarden::*default-store* 'primarvarden::employee employee-id)
    (is (not (primarvarden::first-by-values 'primarvarden::employee :id employee-id)))
    (is (not (primarvarden::first-by-values 'primarvarden::project-person :id employee-project-connection-id)))
    (primarvarden::delete-persistent-object primarvarden::*default-store* project)))
