@echo off
setlocal

REM ============================================================
REM  push to GitHub:  ttkx0725/stzb-ios
REM  KEEP THIS FILE PURE ASCII.
REM  cmd.exe reads .bat as the system ANSI codepage (GBK on Chinese
REM  Windows); UTF-8 Chinese gets mangled and eats adjacent chars.
REM ============================================================

cd /d "%~dp0"

where git >nul 2>nul
if errorlevel 1 (
  echo [X] git not found. Install Git for Windows first:
  echo     https://git-scm.com/download/win
  echo.
  pause
  exit /b 1
)

if not exist .git (
  echo [1/5] git init ...
  git init -b main
  if errorlevel 1 ( echo [X] git init failed. & pause & exit /b 1 )
) else (
  echo [1/5] repo already initialized, skip.
)

REM --- identity: git refuses to commit without it -------------------
REM  Use a repo-local identity so we never touch the user's global config.
git config user.email >nul 2>nul
if errorlevel 1 (
  git config user.email "1260467810@qq.com"
  echo [2/5] set repo-local user.email
) else (
  echo [2/5] user.email already set, skip.
)
git config user.name >nul 2>nul
if errorlevel 1 (
  git config user.name "ttkx0725"
  echo        set repo-local user.name
) else (
  echo        user.name already set, skip.
)

echo [3/5] git add ...
git add -A

echo [4/5] git commit ...
git commit -m "ios native toolchain probe"
if errorlevel 1 (
  echo        nothing to commit, or commit failed -- continuing anyway.
)

echo [5/5] git push ...
git remote remove origin >nul 2>nul
git remote add origin https://github.com/ttkx0725/stzb-ios.git
git push -u origin main
if errorlevel 1 (
  echo.
  echo [X] push failed. Common causes:
  echo     - you cancelled the login popup
  echo     - the repo on GitHub was created WITH a README,
  echo       so it already has commits -- then run:  git pull --rebase origin main
  echo       and run this script again
  echo.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo  Done. Open this page to see the build result:
echo  https://github.com/ttkx0725/stzb-ios/actions
echo ============================================================
echo.
pause
