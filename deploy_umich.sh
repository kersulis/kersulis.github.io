umich="/~kersulis/"
default="/"

sed -i "10s:$default:$umich:" _config.yml
jekyll build

rsync -avz --del _site/ kersulis@web.eecs.umich.edu:public_html/

sed -i "10s:$umich:$default:" _config.yml
jekyll build