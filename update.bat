cd ..
@echo off
:: clone the repository if it doesn't exist
if not exist lep-demonstrator (
	call git clone git@gitlab.ti.bfh.ch:fricg2/lep-demonstrator.git
)

echo RETRIEVING LATEST VERSION FROM REPOSITORY
cd lep-demonstrator

set branches=develop master
(for %%b in (%branches%) do (
	call git fetch origin %%b
	git status -uno | find /i "branch is up to date"
	if errorlevel 1 (
		:: checkout current branch and reset repo to that branch
		call git checkout %%b
		call git reset --hard origin/%%b
		call git status
		if %%b == master (
			call deploy.bat prod
		) else if %%b == develop (
			call deploy.bat dev
		)
	)
))
