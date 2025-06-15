@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 批处理脚本：处理Unreal Engine本地化文件
:: 作者：AI助手
:: 用途：导入本地化数据并重新打包游戏文件

echo 开始处理Unreal Engine本地化文件...

:: 步骤1：执行UnrealLocres导入命令
echo 步骤1: 导入本地化数据...
"UnrealLocres/UnrealLocres.exe" import "UnrealLocres/Game.locres" "UnrealLocres/GameText.csv"
if errorlevel 1 (
    echo [错误] 本地化数据导入失败
    pause
    exit /b 1
) else (
    echo [成功] 本地化数据导入成功
)

:: 步骤2：处理生成的locres文件
echo 步骤2: 处理生成的locres文件...

set "sourceFile=UnrealLocres\Game.locres.new"
set "targetDir=UnrealPak\FNAF_SOTM\Content\Localization\Game\en"
set "targetFile=%targetDir%\Game.locres"

:: 检查源文件是否存在
if not exist "%sourceFile%" (
    echo [错误] 源文件不存在: %sourceFile%
    pause
    exit /b 1
)

:: 确保目标目录存在
if not exist "%targetDir%" (
    echo 创建目标目录: %targetDir%
    mkdir "%targetDir%" 2>nul
)

:: 删除旧的Game.locres文件（如果存在）
if exist "%targetFile%" (
    echo 删除旧的Game.locres文件...
    del "%targetFile%" /f /q
    if errorlevel 1 (
        echo [错误] 无法删除旧文件: %targetFile%
        pause
        exit /b 1
    )
)

:: 复制新文件到目标位置
copy "%sourceFile%" "%targetFile%" >nul
if errorlevel 1 (
    echo [错误] 文件复制失败: %sourceFile% -^> %targetFile%
    pause
    exit /b 1
) else (
    echo [成功] 文件复制成功: %sourceFile% -^> %targetFile%
)

:: 步骤3：执行UnrealPak打包命令
echo 步骤3: 重新打包游戏文件...

:: 保存当前目录
set "originalDir=%CD%"

:: 切换到UnrealPak目录
set "unrealPakDir=UnrealPak\v11.27\2\3"
if not exist "%unrealPakDir%" (
    echo [错误] UnrealPak目录不存在: %unrealPakDir%
    pause
    exit /b 1
)

cd /d "%unrealPakDir%"

:: 执行打包命令
"UnrealPak.exe" "..\..\..\..\FNAF_SOTM-WindowsNoEditor_p.pak" "-Create=..\..\..\FNAF_SOTM.txt" "-compress"
if errorlevel 1 (
    echo [错误] 游戏文件打包失败
    cd /d "%originalDir%"
    pause
    exit /b 1
) else (
    echo [成功] 游戏文件打包成功
)

:: 恢复原始工作目录
cd /d "%originalDir%"

echo 所有步骤完成！本地化文件处理成功。
pause 