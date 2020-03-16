cd ..
@echo off
:: clone the repository if it doesn't exist
if not exist lep-demonstrator (
	call git clone git@gitlab.ti.bfh.ch:fricg2/lep-demonstrator.git
)

echo RETRIEVING LATEST VERSION FROM REPOSITORY
cd lep-demonstrator

call git fetch origin
call git checkout .

set branches=develop master
(for %%b in (%branches%) do (
	call git checkout %%b
	call git status -uno | find /i "branch is up to date"
	if errorlevel 1 (
		:: checkout current branch and reset repo to that branch
		call git status
		if %%b == master (
			call deploy.bat prod
		) else if %%b == develop (
			call deploy.bat dev
		)
	)
))
