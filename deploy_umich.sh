umich="/~kersulis/"
default="/"

sed "10s:$default:$umich:" _config.yml
jekyll build
sed "10s:$umich:$default:" _config.yml
scp -r _site/* kersulis@web.eecs.umich.edu:public_html