@echo off
setlocal

REM ============================================================
REM  push to GitHub:  ttkx0725/stzb-ios
REM  KEEP THIS FILE PURE ASCII.
REM ============================================================

cd /d "%~dp0"

where git >nul 2>nul
if errorlevel 1 (
  echo [X] git not found. Install Git for Windows first:
  echo     https://git-scm.com/download/win
  pause & exit /b 1
)

if not exist .git ( git init -b main )

REM --- repo-local identity (never touches global config) -------------
git config user.email >nul 2>nul
if errorlevel 1 git config user.email "1260467810@qq.com"
git config user.name >nul 2>nul
if errorlevel 1 git config user.name "ttkx0725"

echo [1/3] git add ...
git add -A

echo [2/3] git commit ...
git commit -m "ios native toolchain probe"

echo [3/3] git push ...
git remote remove origin >nul 2>nul
git remote add origin https://github.com/ttkx0725/stzb-ios.git

REM --- attempt 1: as configured (may go through a local proxy) -------
git push -u origin main
if not errorlevel 1 goto ok

echo.
echo [i] push failed -- retrying with the proxy DISABLED for this command only.
echo     (git is configured to use a proxy that is not currently running)
echo.

REM --- attempt 2: bypass proxy for this single invocation ------------
REM  -c http.proxy=  clears it for this command only; global config untouched.
git -c http.proxy= -c https.proxy= push -u origin main
if not errorlevel 1 goto ok

echo.
echo ============================================================
echo  [X] both attempts failed.
echo.
echo  Most likely: no route to github.com right now.
echo  Try one of these, then run this script again:
echo.
echo    A) start your proxy app (Clash / v2ray / etc.)
echo       git is pointed at  http://127.0.0.1:7897
echo.
echo    B) or point git at the proxy that IS listening on 1080:
echo       git config --global http.proxy  socks5://127.0.0.1:1080
echo       git config --global https.proxy socks5://127.0.0.1:1080
echo.
echo    C) or go direct (works if github is reachable without proxy):
echo       git config --global --unset http.proxy
echo       git config --global --unset https.proxy
echo ============================================================
pause & exit /b 1

:ok
echo.
echo ============================================================
echo  Done. Open this page to see the build result:
echo  https://github.com/ttkx0725/stzb-ios/actions
echo ============================================================
pause
