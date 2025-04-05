@echo off

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

%NWB_DIR%\update_ignores.bat
%MCP_BIN% recompile
%MCP_BIN% build
