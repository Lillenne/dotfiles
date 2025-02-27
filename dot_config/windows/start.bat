@ECHO OFF
vcxsrv.exe :0 -multiwindow -clipboard -wgl -ac -background none -noreset
start wt
timeout /t 35 /nobreak
C:\Windows\System32\cmd.exe /c start /min wsl bash -ic "emacsclient -c"
timeout /t 8 /nobreak
C:\Users\austin.kearns\scoop\apps\glazewm\current\cli\glazewm.exe start --config="C:\Users\austin.kearns\.config\glazewm\config.yml"