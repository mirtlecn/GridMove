& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in GridMove.ahk /out Installer/GridMove.exe /icon GridMove.ico

Get-ChildItem .\Installer\ -Exclude GridMove-Setup*,GridMove-Portable* | Compress-Archive -DestinationPath .\Installer\GridMove-Portable.zip -CompressionLevel Fastest -Force

& "C:\Program Files (x86)\Inno Setup 6\iscc.exe" Compile.iss

