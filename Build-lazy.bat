@echo off

lune run Build bundle output=Tests/Script.luau
lune run Build bundle output=Tests/Script-Minified.luau minify=true

pause
