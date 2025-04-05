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

:: Download RetroMCP-Java
if not exist "%BIN_DIR%" (
    echo ==================================================
    echo Downloading RetroMCP-Java by MCPHackers
    echo ==================================================
    mkdir "%BIN_DIR%"
    curl.exe -L -o %BIN_DIR%\mcp.jar "https://github.com/MCPHackers/RetroMCP-Java/releases/download/v1.0/RetroMCP-Java-CLI.jar" > nul
)

:: Setup Workspace
echo ==================================================
echo Setting up RetroMCP-Java workspace for b1.7.3
echo ==================================================


if not exist "%CLIENT_DIR%" (
    mkdir "%CLIENT_DIR%"
)

if not exist "%SERVER_DIR%" (
    mkdir "%SERVER_DIR%"
)

move %CLIENT_DIR% %NWB_DIR%\tmp
move %SERVER_DIR% %NWB_DIR%\tmp

%MCP_BIN% setup b1.7.3
%MCP_BIN% decompile

xcopy /e /h /y "%NWB_DIR%\tmp\minecraft\" "%CLIENT_DIR%\"
xcopy /e /h /y "%NWB_DIR%\tmp\minecraft_server\" "%SERVER_DIR%\"

rmdir /s /q "%NWB_DIR%\tmp\minecraft"
rmdir /s /q "%NWB_DIR%\tmp\minecraft_server"

:: Delete Eclipse shit
rmdir /s /q "%CLIENT_DIR%\.settings"
del "%CLIENT_DIR%\.classpath"
del "%CLIENT_DIR%\.project"
del "%CLIENT_DIR%\Client.launch"

rmdir /s /q "%SERVER_DIR%\.settings"
del "%SERVER_DIR%\.classpath"
del "%SERVER_DIR%\.project"
del "%SERVER_DIR%\Server.launch"


:: Setup Intelij Configuration

echo ==================================================
echo Setting up Intelij Configuration
echo ==================================================

if not exist "%BASE_DIR%\.idea\libraries" (
    mkdir "%BASE_DIR%\.idea\libraries"
)

echo Copying "%XML_DIR%\libraries.xml => %BASE_DIR%\.idea\libraries\libraries.xml"
copy "%XML_DIR%\libraries.xml" "%BASE_DIR%\.idea\libraries" > nul


echo Copying "%XML_DIR%\modules.xml => %BASE_DIR%\.idea\libraries\modules.xml"
copy "%XML_DIR%\modules.xml" "%BASE_DIR%\.idea\modules.xml" > nul

echo Copying "%XML_DIR%\misc.xml => %BASE_DIR%\.idea\libraries\misc.xml"
copy "%XML_DIR%\misc.xml" "%BASE_DIR%\.idea\misc.xml" > nul

echo Copying "%XML_DIR%\workspace.xml => %BASE_DIR%\.idea\workspace.xml"
copy "%XML_DIR%\workspace.xml" "%BASE_DIR%\.idea\workspace.xml" > nul


:: Generate Intelij Modules
if not exist "%BASE_DIR%\.idea\runConfigurations" (
    mkdir "%BASE_DIR%\.idea\runConfigurations"
)

echo Copying "%XML_DIR%\module.xml => %CLIENT_DIR%\Client.iml"
copy "%XML_DIR%\module.xml" "%CLIENT_DIR%\Client.iml" > nul



echo Copying "%XML_DIR%\module.xml => %SERVER_DIR%\Server.iml"
copy "%XML_DIR%\module.xml" "%SERVER_DIR%\Server.iml" > nul

:: Client Module 
echo Generating "%BASE_DIR%\.idea\runConfigurations\Client.xml"
(
echo ^<component name="ProjectRunConfigurationManager"^>
echo   ^<configuration default="false" name="Client" type="Application" factoryName="Application"^>
echo     ^<option name="MAIN_CLASS_NAME" value="org.mcphackers.launchwrapper.Launch" /^>
echo     ^<module name="Client" /^>
echo     ^<option name="PROGRAM_PARAMETERS" value="--username natowb --session - --version b1.7.3 --gameDir %CLIENT_GAME_DIR% --assetsDir %CLIENT_ASSETS_DIR% --assetIndex b1.7 --accessToken - --userProperties {} --userType legacy --versionType release --skinProxy pre-b1.9-pre4" /^>
echo     ^<option name="VM_PARAMETERS" value="-Djava.library.path=%NATIVE_LIB_PATH%" /^>
echo     ^<method v="2"^>
echo       ^<option name="Make" enabled="true" /^>
echo     ^</method^>
echo   ^</configuration^>
echo ^</component^>
) > "%BASE_DIR%\.idea\runConfigurations\Client.xml"


:: Server Module



echo Generating "%BASE_DIR%\.idea\runConfigurations\Server.xml"
(
echo ^<component name="ProjectRunConfigurationManager"^>
echo   ^<configuration default="false" name="Server" type="Application" factoryName="Application"^>
echo     ^<option name="ALTERNATIVE_JRE_PATH" value="corretto-1.8" /^>
echo     ^<option name="ALTERNATIVE_JRE_PATH_ENABLED" value="true" /^>
echo     ^<option name="MAIN_CLASS_NAME" value="net.minecraft.server.MinecraftServer" /^>
echo     ^<module name="Server" /^>
echo     ^<option name="VM_PARAMETERS" value="-Djava.library.path=%NATIVE_LIB_PATH%" /^>
echo     ^<option name="WORKING_DIRECTORY" value="%SERVER_GAME_DIR%" /^>
echo     ^<method v="2"^>
echo       ^<option name="Make" enabled="true" /^>
echo     ^</method^>
echo   ^</configuration^>
echo ^</component^>
) > "%BASE_DIR%\.idea\runConfigurations\Server.xml"