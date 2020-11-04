
1. Basic concpets
The purpose of the scripts is to manage a SVN project repo easily remotely: creating new accounts, access rights modifications etc.
This is to avoid the limitation of remote access in a company (IT often not allowed)
By have only one shot setting in remote server, the SVN administrators can manage repositories remotely.
The settings assume that there is only one repo in server side, all projects are managed in one repo but in different folders.

:: Folder architecture in SVN server PC
:: AccountsDB (SVN Repo)
::      |
::      |-- conf
::             |-- svnserve.conf
::      |-- hooks
::             |-- post-commit.bat
::      |
::
:: ProjectsDB (SVN Repo)
::      |
::      |-- conf
::             |-- authz
::             |-- passwd
::             |-- svnserve.conf
::      |-- hooks
::      |
::       
:: Accounts (SVN working copy)
::      |
::      |-- authz
::      |-- passwd

Contents inside "ProjectDB"
  
  ProjectDB
  |
  |- project1
  |
  |- project2

2.Steps to use the settings in SVN server PC
a) create a "ProjectsDB" repo in SVN server PC
b) create a "AccountsDB" repo in SVN server PC
c) checkout a working copy in SVN server PC: "Accounts" from "AccountsDB"
d) replace the default "svnserve.conf" for "AccountsDB" and "ProjectsDB", this enables authorization for both repos
e) add hooks for "AccountsDB": post-commit.bat, make sure to modify VARIABLES related to file paths
f) start SVN server, refer to "svnserve_run.bat" detail.

3. Steps in remote PC
a) checkout "AccountsDB", commit the authorization files: authz and passwd.
Note: you can also check on SVN server PC to make sure everything is working well before going to remote PC
b) checkout "ProjectsDB", and try access rights and user names
