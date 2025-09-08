@echo off

cd C:\Users\MikeFeng\OneDrive\MFeee-New

lune run Build minify=true darklua-config-path="Build/DarkluaNormal.json" output="Tests/Script.luau"
lune run Build minify=true darklua-config-path="Build/DarkluaMinify.json" output="Tests/Script-Minified.luau"
