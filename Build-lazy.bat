@echo off

lune run Build bundle output="Tests/Script.luau"
lune run Build bundle minify=true darklua-config-path="Build/DarkluaNormal.json" output="Tests/Script-Formatted.luau"
lune run Build bundle minify=true darklua-config-path="Build/DarkluaMinify.json" output="Tests/Script-Minified.luau"
