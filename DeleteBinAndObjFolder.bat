for /d /r . %%d in (bin,obj) do @if exist "%%d" rd /s/q "%%d"
for /d /r . %%d in (_UpgradeReport_Files,Backup) do @if exist "%%d" rd /s/q "%%d"
del UpgradeLog*.htm
del UpgradeLog*.XML
RD "%LocalAppData%\Temp\Temporary ASP.NET Files\root\" /S /Q