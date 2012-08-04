(in-package :primarvarden)

(defun find-by-values (class &rest args &key (test #'equal) &allow-other-keys)
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

    (find-persistent-objects *default-store* class :filter #'filter-by-values)))

(defmacro capture-weblocks-output (&body body)
  `(let ((*weblocks-output-stream* (make-string-output-stream)))
     ,@body 
     (get-output-stream-string *weblocks-output-stream*)))

(defun all-of (cls &key order-by)
  (find-persistent-objects *default-store* cls :order-by order-by))
