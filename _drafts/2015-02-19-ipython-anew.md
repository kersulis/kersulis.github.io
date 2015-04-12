---
layout: post
title: IPython Anew
---

I have spent more time trying to install Python 2 and Python3 simultaneously than I care to admit. After several credible recommendations, I decided to use virtual environments. I'm enjoying the experience so far. My ultimate goal is to have a clean, self-contained directory that can run the IPython notebook with Python 3, has nbgrader, and has a Julia kernel installed. This will make it easy to make assignment notebooks for the interactive textbook I envision.

1. Get virtualenv

2. Make a new virtualenv with Python3. I used [these instructions](http://blog.troygrosfield.com/2014/01/09/making-move-python3-virtualenvs-pip/) with one important modification. Because my system `pip` installation was unbelievable and irreparably messed up, the very first command wouldn't work. So I added the `--no-pip` option to start without `pip`. After activating the new, package-free environment, I followed the instructions [here](https://pip.pypa.io/en/latest/installing.html) to get an appropriate version of `pip`.

3. Install IPython into the virtualenv directory. The following commands from [here](http://ipython.org/ipython-doc/dev/install/install.html#installing-ipython-itself) should do it:
```bash
pip install "ipython[all]"
git clone --recursive https://github.com/ipython/ipython.git
cd ipython
python setupegg.py develop
```

4. Install other packages:

```bash
pip install numpy
pip install matplotlib
pip install pandas
pip install scipy
pip install autopep8
pip install pymongo

sudo apt-get install gfortran libopenblas-dev liblapack-dev
pip install scipy
```

5. Install `nbgrader`. Just clone the repo into the virtualenv directory.

At this point I was able to run `ipython notebook` without errors. Without any additional setup, I had my Julia and MATLAB kernels from the system-wide IPython installation I was using before. This is because my new virtualenv IPython installation is using the same `~/.ipython` directory, which contains kernel registration instructions. The other thing my new IPython installation shares with the old is Julia: I did not need to re-install Julia or any packages. This behavior happens to be convenient for me; it would have been a hassle to start over with Julia.