
(in-package :primarvarden)

(export '(start-primarvarden stop-primarvarden))

(defun start-primarvarden (&rest args)
  "Starts the application by calling 'start-weblocks' with appropriate
  arguments."
  (apply #'start-weblocks args))

(defun stop-primarvarden ()
  "Stops the application by calling 'stop-weblocks'."
  (stop-webapp 'primarvarden)
  (stop-weblocks))

;;; A sandbox store macro
(defmacro sandbox-store ()
  "Access to a sandbox store in the session."
  `(hunchentoot:session-value 'sandbox-store))

;; Define our application
(defwebapp primarvarden :prefix ""
           :autostart t
           :public-files-cache-time 100000
	   :description "A web application based on Weblocks"
	   :dependencies '((:stylesheet "suggest")))

