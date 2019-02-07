# License
See LICENSE.txt for the license text and for a short description of the project.

# Installation
You do not need to install anything since the Git repository holds all necessary libraries (libs) and the compiler and runtime SBCL (Linux 64 bit). The Git repository consist of the Git submodules quicklisp and sbcl, which are required for it to run. If already have sbcl and the quicklisp libs, then it is not a necessity to clone them. You need however to make sure that you have the right libs in quicklisp and a version of sbcl that will work.

# Directory structure and most relevant files and directories
* primarvarden/: main Git repository
    * quicklisp/: libs such as weblocks and all its dependencies, Git submodule
        * local-projects/: local project that isn't part of Quicklisp.
    * sbcl/: compiler and runtime for Linux 64 bit, Git submodule
    * webapp/: the web application itself
        * data/: database snapshots directory
        * script/server: run server, read documentation in the script for how it works.
        * script/init-d-service: run server as a daemon. Create a symbolic link to the directory /etc/init.d
        * script/update-libraries-links: link all asds from quicklisp systems directory and local-projects directory to lib/systems. Does not overwrite links
        * script/selenium-server see section below
        * test-data/: directory to save snapshots with sample data if schema changed.
        * tests/: testing with selenium, to make tests pass, start selenium with *script/selenium-server* before running tests.

# Run as a service
If you are going to run the web application as a service, install screen (should be available in the archive for most GNU/Linux distributions. Then copy or create a symbolic link from the file webapp/script/init-d-service in /etc/init.d/

Make sure to change the environment variables USER and DAEMON to your environment and make sure the script is executable.

If you would like the application to start automatically when booting your computer. First make sure you have done above things. Install the init script as a startup script with:
update-rc.d primarvarden defaults (e.g. for Debian and Ubuntu systems)

