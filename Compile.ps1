& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in GridMove.ahk /out build/GridMove.exe /icon GridMove.ico

Get-ChildItem .\build\ -Exclude "GridMove-Setup*","GridMove-Portable*" | Compress-Archive -DestinationPath .\build\GridMove-Portable.zip -CompressionLevel Fastest -Force

& "C:\Program Files (x86)\Inno Setup 6\iscc.exe" Inno.iss

