(push #p"/usr/lib/sbcl/site/cl-weblocks/" asdf:*central-registry*)
(push #p"/usr/lib/sbcl/site/cl-weblocks/examples/primarvarden/" asdf:*central-registry*)
(asdf:operate 'asdf:load-op :primarvarden)
(primarvarden:start-primarvarden)
