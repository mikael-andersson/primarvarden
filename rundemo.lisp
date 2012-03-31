(push #p"/usr/lib/sbcl/site/cl-weblocks/" asdf:*central-registry*)
(push #p"/home/mikael/Common-Lisp/own-projects/primarvarden/" asdf:*central-registry*)
(asdf:operate 'asdf:load-op :primarvarden)
(primarvarden:start-primarvarden)
