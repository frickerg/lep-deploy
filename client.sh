host='Admin@147.87.116.202'
devpath='C:\dev\'
gitrepo='lep-deploy'

echo "target directory : ${devpath}"

ssh ${host} "cd ${devpath} && if exist ${gitrepo} rmdir /s /q ${gitrepo}"
ssh ${host} "cd ${devpath} && git clone https://github.com/frickerg/${gitrepo}.git"
if [ "$1" != "" ]; then
	ssh ${host} -tt "cd ${devpath}\\${gitrepo} && deploy.bat $1 $2"
else
	ssh ${host} -tt "cd ${devpath}\\${gitrepo} && deploy.bat prod"
fi
