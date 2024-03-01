& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in GridMove.ahk /out build/GridMove-F16.exe /icon GridMove.ico

Get-ChildItem .\build\ -Exclude "GridMove-Setup*","GridMove-Portable*" | Compress-Archive -DestinationPath .\build\GridMove-F16-Portable.zip -CompressionLevel Fastest -Force

& "C:\Program Files (x86)\Inno Setup 6\iscc.exe" Inno.iss

