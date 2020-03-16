cd .. && cd lep-demonstrator

@echo off
set branches=develop master
(for %%branch in (%branches%) do (
	call git checkout %%branch
	git status -uno | find /i "branch is up to date"
	if errorlevel 1 (
		call git reset --hard origin/%BRANCH%
		call git status
		call deploy.bat %%branch
	)
))
