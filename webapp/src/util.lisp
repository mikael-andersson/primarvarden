(in-package :primarvarden)

(defun prevalence-poweredp ()
  (eq (class-name  (class-of *default-store*)) 'cl-prevalence:guarded-prevalence-system))

(defun find-by (class fun &key order-by range)
  (if (prevalence-poweredp)
    (find-persistent-objects *default-store* class 
                             :filter fun 
                             :order-by order-by 
                             :range range)
    (find-persistent-objects *default-store* class 
                             :filter-fn 
                             (lambda (item) (not (funcall fun item))) 
                             :order-by order-by 
                             :range range)))

(defun find-by-values (class &rest args &key (test #'equal) &allow-other-keys)
  (let ((*package* (find-package :primarvarden)))
    (flet ((filter-by-values (object)
             (loop for key in args by #'cddr do 
                   (let ((value (getf args key))
                         (test-fun test))
                     (when (and (consp value) (functionp (cdr value)))
                       (setf test-fun (cdr value))
                       (setf value (car value)))
                     (unless (funcall test value (slot-value object (intern (string  key))))
                       (return-from filter-by-values nil))))
             t))

      (find-persistent-objects *default-store* class :filter #'filter-by-values))))

(defun first-by-values (&rest args)
  (first (apply #'find-by-values args)))

(defmacro capture-weblocks-output (&body body)
  `(let ((*weblocks-output-stream* (make-string-output-stream)))
     ,@body 
     (get-output-stream-string *weblocks-output-stream*)))

(defun all-of (cls &key order-by range)
  (find-persistent-objects *default-store* cls :order-by order-by :range range))
