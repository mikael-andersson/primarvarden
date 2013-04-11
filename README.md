# Installation
You do not need to install anything since the git repository holds all necessary libraries and the compiler and runtime SBCL.

# Directory structure and most relevant files and directories
* primarvarden/: main git repository
    * quicklisp/: libraries such as weblocks and all its dependencies, git submodule
        * local-projects/: local project that isn't part of Quicklisp.
    * sbcl/: compiler and runtime for Linux 64 bit, git submodule
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
