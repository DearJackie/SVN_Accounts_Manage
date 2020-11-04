:: Folder architecture in SVN server PC
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



:: daemon mode
:: To increase security, you can pass the -r option to svnserve, which restricts it to exporting only repositories below that path,
:: Using the -r option effectively modifies the location that the program treats as the root of the remote filesystem space
:: svnserve -d -r d:\Work\Repository\SVNServerRepos\ProjectsDB  --listen-host hostname --listen-port portid
:: default port id: 3690
svnserve -d -r d:\Work\

:: svnserve as a Windows service (there must be a space after "= ", such as "binpath= "
sc.exe svn_server binpath= "C:\svn\bin\svnserve.exe --service -r C:\repos" displayname= "SVN Server" depend = Tcpip start= auto

:: try on local PC
:: access repository inside root specified above: d:\Work\Repository\SVNServerRepos\ProjectsDB
:: localhost: full computer name (my computer -> properties)
:: svn://localhost

PAUSE