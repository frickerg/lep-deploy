host='Admin@147.87.116.202'
devpath='C:\dev\'
gitrepo='lep-deploy'

echo "target directory : ${devpath}"

ssh ${host} "cd ${devpath} && if exist ${gitrepo} rmdir /s /q ${gitrepo}"
ssh ${host} "cd ${devpath} && git clone -b develop https://github.com/frickerg/${gitrepo}.git"
ssh ${host} -tt "cd ${devpath}\\${gitrepo} && deploy.bat dev && deploy.bat prod"
