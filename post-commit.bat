:: The post-commit hook is invoked after a commit.  Subversion runs
:: this hook by invoking a program (script, executable, binary, etc.)
:: named 'post-commit' (for which this file is a template) with the 
:: following ordered arguments:
::
::   [1] REPOS-PATH   (the path to this repository)
::   [2] REV          (the number of the revision just committed)
::   [3] TXN-NAME     (the name of the transaction that has become REV)
::
:: The default working directory for the invocation is undefined, so
:: the program should set one explicitly if it cares.
::
:: Because the commit has already completed and cannot be undone,
:: the exit code of the hook program is ignored.  The hook program
:: can use the 'svnlook' utility to help it examine the
:: newly-committed tree.
::
:: On a Unix system, the normal procedure is to have 'post-commit'
:: invoke other programs to do the real work, though it may do the
:: work itself too.
::
:: Note that 'post-commit' must be executable by the user(s) who will
:: invoke it (typically the user httpd runs as), and that user must
:: have filesystem-level permission to access the repository.
::
:: On a Windows system, you should name the hook program
:: 'post-commit.bat' or 'post-commit.exe',
:: but the basic idea is the same.
:: 
:: The hook program typically does not inherit the environment of
:: its parent process.  For example, a common problem is for the
:: PATH environment variable to not be set to its usual value, so
:: that subprograms fail to launch unless invoked via absolute path.
:: If you're having unexpected problems with a hook program, the
:: culprit may be unusual (or missing) environment variables.
:: 
:: Here is an example hook script, for a Unix /bin/sh interpreter.
:: For more examples and pre-written hooks, see those in
:: the Subversion repository at
:: http://svn.apache.org/repos/asf/subversion/trunk/tools/hook-scripts/ and
:: http://svn.apache.org/repos/asf/subversion/trunk/contrib/hook-scripts/
::
::
:: The script is part of SVN accounts management from local(not on SVN server side), such as create new SVN
:: users and grant new access rights for different SVN repository folders.
:: The assumption is that only one SVN repository is created on server side for all projects.
:: The concept is as following:
:: a) 2 repositories in SVN server: 1 accounts repository("AccountsDB)" and 1 projects repository("ProjectsDB").
::    Only SVN server administrator can access "AccountsDB", all user access right files are managed by this 
::    database, ie. "authz" and "passwd" of "ProjectsDB" repository is the content of "AccountsDB" repository.
:: b) 1 working copy("Accounts") in SVN server side, checking out from repository "AccountsDB".
:: c) 1 working copy("Projects") in SVN adminstrator's local PC, checking out from repository "AccountsDB".
::    The initial files are directly copied from "ProjectsDB\conf" manually.
:: d) each time when the SVN administrator commits his modification(new user, modify access rights etc.), the 
::    "post-commit.bat" of "AccountsDB" runs in SVN server side; The "post-commit.bat" script performs the 
::    "update" for working copy of "AccountsDB", and then "copy" the updated local working files("authz" and "passwd")
::    to repository folder "ProjectsDB\conf" of "ProjectsDB".
::
:: Folder architecture in SVN server:
:: AccountsDB (SVN Repo)
::      |
::      |-- conf
::      |-- hooks
::             |-- post-commit.bat
::      |
::
:: ProjectsDB (SVN Repo)
::      |
::      |-- conf
::             |-- authz
::             |-- passwd
::      |-- hooks
::      |
::       
:: Accounts (SVN working copy)
::      |
::      |-- authz
::      |-- passwd

:: This post commit script is for SVN "AccountsDB" repository.

@ECHO ON

SET REPOS=%1
SET REV=%2
SET TXN_NAME=%3
set LOGFILE=%REPOS%\hooks\log-file.txt

:: Redirect all outputs to a file
CALL :sub >%logfile%

:: exit the current batch script instead of CMD.exe
EXIT /b

:: Label to indirect all outputs to file
:sub
::ECHO %REPOS%
::ECHO %REV%
::ECHO %TXN_NAME%
::ECHO %LOGFILE%

:: There shall be no space after the variable definition left and right side of "="
:: AccountsDB repository path
SET ACCOUNTS_DB_PATH=%REPOS%

:: ProjectsDB repository path
SET PROJECTS_DB_PATH=%ACCOUNTS_DB_PATH%\..\ProjectsDB

:: Accounts working copy path in SVN server
SET WORKING_PATH=%ACCOUNTS_DB_PATH%\..\Accounts

:: SVN command line path
SET SVN_CMD_PATH="c:\Program Files\TortoiseSVN\bin"

:: Trigger the "update" command of working copy in SVN server side for "AccountsDB",
:: since the "commit" is done by another working copy in remote PC.
:: :"= is to remove both quotes from the string in SVN_CMD_PATH
"%SVN_CMD_PATH:"=%\svn.exe" update %WORKING_PATH%

:: Latest accounts files are now in "Accounts" working copy in SVN server PC
:: copy the updated accounts to "AccountsDB" repository and "ProjectDB" repository, two repositories
:: share the same accounts file, this is to ease the management and maintainence.
COPY %WORKING_PATH%\authz  %PROJECTS_DB_PATH%\conf  /Y
COPY %WORKING_PATH%\passwd %PROJECTS_DB_PATH%\conf  /Y

COPY %WORKING_PATH%\authz  %ACCOUNTS_DB_PATH%\conf  /Y
COPY %WORKING_PATH%\passwd %ACCOUNTS_DB_PATH%\conf  /Y

::PAUSE
