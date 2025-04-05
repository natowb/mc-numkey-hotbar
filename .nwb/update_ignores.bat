@echo off
setlocal enabledelayedexpansion


set BASE_DIR=%cd%

set NWB_DIR=%BASE_DIR%\.nwb
set XML_DIR=%NWB_DIR%\idea_xmls
set BIN_DIR=%NWB_DIR%\bin
set SCRIPTS_DIR=%NWB_DIR%\scripts

set CLIENT_DIR=%BASE_DIR%\minecraft
set CLIENT_GAME_DIR=%CLIENT_DIR%\game
set CLIENT_ASSETS_DIR=%CLIENT_DIR%\game\assets
set SERVER_DIR=%BASE_DIR%\minecraft_server
set SERVER_GAME_DIR=%SERVER_DIR%\game
set NATIVE_LIB_PATH=%BASE_DIR%\libraries\natives

set MCP_BIN=java -jar %BIN_DIR%\mcp.jar

%MCP_BIN% createpatch

:: Set the path to the client.patch file
set CLIENT_PATCH_FILE=%BASE_DIR%\patches\client.patch
set CLIENT_IGNORE_FILE=%CLIENT_DIR%\.gitignore

> "%CLIENT_IGNORE_FILE%" echo #This file it auto generated do not modify

:: Check if the patch file exists
if exist "%CLIENT_PATCH_FILE%" (
    :: Loop through the file line by line
    for /f "tokens=*" %%A in (%CLIENT_PATCH_FILE%) do (
        set line=%%A

        :: Check if the line starts with "+++"
        if "!line!" neq "" if "!line:~0,3!" == "+++" (
            :: Extract and echo the file path after "+++ "
            set file_path=!line:~4!
            echo ^^!src/!file_path! >> %CLIENT_IGNORE_FILE%
        )
    )
)




:: Set the path to the server.patch file
set SERVER_PATCH_FILE=%BASE_DIR%\patches\server.patch
set SERVER_IGNORE_FILE=%SERVER_DIR%\.gitignore

> "%SERVER_IGNORE_FILE%" echo #This file it auto generated do not modify

:: Check if the patch file exists
if exist "%SERVER_PATCH_FILE%" (
    :: Loop through the file line by line
    for /f "tokens=*" %%A in (%SERVER_PATCH_FILE%) do (
        set line=%%A

        :: Check if the line starts with "+++"
        if "!line!" neq "" if "!line:~0,3!" == "+++" (
            :: Extract and echo the file path after "+++ "
            set file_path=!line:~4!
            echo ^^!src/!file_path! >> %SERVER_IGNORE_FILE%
        )
    )
)



endlocal