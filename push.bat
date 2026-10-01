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

git config user.email >nul 2>nul
if errorlevel 1 git config user.email "1260467810@qq.com"
git config user.name >nul 2>nul
if errorlevel 1 git config user.name "ttkx0725"

echo [1/4] git add ...
git add -A

echo [2/4] git commit ...
git commit -m "ios native toolchain probe"

git remote remove origin >nul 2>nul
git remote add origin https://github.com/ttkx0725/stzb-ios.git

REM ---------------------------------------------------------------
REM Proxy note: git is configured for http://127.0.0.1:7897 but that
REM proxy is often not running. Every network command below is given
REM -c http.proxy= -c https.proxy= so it connects DIRECTLY, without
REM touching your global git config.
REM ---------------------------------------------------------------

echo [3/4] git fetch + rebase (merge whatever is already on GitHub) ...
echo        if the repo was created with a README, this reconciles it.
git -c http.proxy= -c https.proxy= fetch origin main
if not errorlevel 1 (
  git -c http.proxy= -c https.proxy= rebase origin/main
  if errorlevel 1 (
    echo        rebase hit a conflict -- falling back to merge.
    git rebase --abort >nul 2>nul
    git -c http.proxy= -c https.proxy= merge origin/main --allow-unrelated-histories -m "merge remote"
  )
) else (
  echo        remote branch not found yet -- first push, nothing to merge.
)

echo [4/4] git push ...
git -c http.proxy= -c https.proxy= push -u origin main
if errorlevel 1 (
  echo.
  echo ============================================================
  echo  [X] push failed.
  echo.
  echo  If it says 'Failed to connect' -- no route to github.com.
  echo    A) start your proxy app (git points at 127.0.0.1:7897)
  echo    B) or:  git config --global http.proxy socks5://127.0.0.1:1080
  echo    C) or:  git config --global --unset http.proxy
  echo.
  echo  Otherwise copy the error text and send it over.
  echo ============================================================
  pause & exit /b 1
)

echo.
echo ============================================================
echo  Done. Open this page to see the build result:
echo  https://github.com/ttkx0725/stzb-ios/actions
echo ============================================================
pause
