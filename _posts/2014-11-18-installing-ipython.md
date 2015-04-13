---
layout: post
title: Installing IPython
image: battlestation.jpg
color: white
---

> An expert is a man who has made all the mistakes which can be made, in a narrow field.
~ Niels Bohr

#I am now an expert at installing IPython.

<!-- This past summer I had an internship at LANL, and I decided to re-tool. I replaced every computing utility I assumed was great with one that was actually great. I moved from Windows to Ubuntu. I installed Julia to replace MATLAB's technical computing capabilities. Instead of using AMPL for my optimization research work, I installed the JuMP Julia package (whose author sat at the desk next to mine). Throughout this turbulent time, two pieces of software continually assured me that I was doing the right thing by switching: Ubuntu and IPython.

The IPython notebook revolutionized my research work. Instead of developing scripts in MATLAB and passing data somewhere else to plot network graphs, I could use [NetworkX][1] and [GraphViz][2] to generate a crisp, beautiful SVG and display it inline. With IPython, it became dead simple to document my work with Markdown rather than creating LaTeX documents, or worse, using MS Word. I build up a significant amount of Julia research code, and spent most of each day in an IJulia notebook. When my internship came to an end, I set work aside and spent a month with my family.

When fall came around, I decided to continue applying what I had learned about IPython to my new set of classes. My signal processing professor wanted to write an interactive textbook that stood above the rest. I recommended that we create a set of IPython notebooks to accomplish the task. Awesome examples like [numerical-mooc][3] show how easy it is to do this. -->

Recently I returned to the IPython notebook to pick up research and textbook writing. Knowing the current stable version would be obsolete by the time my textbook could be deployed, I switched to the [development version][4]. Well, at least I *tried* to switch to the development version. I followed the installation instructions, but couldn't get the IJulia profile to work. Because I rely on Julia for my research, this is no good. I re-built the IJulia package [as the developer suggests][11], but nothing happened. I spent all afternoon today trying to simultaneously figure out what was wrong and somehow get my IPython installation to match the [uber-notebook][6] [Kyle Kelley][5] put on tmpnb.

I finally figured it out. The key was to dig into [the][7] [Dockerfiles ][8] used to build tmpnb. I want to share what I learned in hopes that it will help others in my situation (all two of them).

Though the development version of IPython boasts multi-kernel support, and every demonstration includes it, I haven't found any instructions for setting it up. Installing from the Github repository will make the notebook work for your current `python` executable is easy; having it recognize multiple versions of Python along with Julia and Bash is a tad harder, and it certainly doesn't set itself up. So I'm going to show you how to set up IPython's development version, with two Python kernels and a Julia kernel, from scratch.

The [IPython notebook Dockerfile][7] shows how easy it is to install all IPython dependencies across multiple versions of Python:

```bash
sudo apt-get update && apt-get install -y -q \
    build-essential \
    make \
    gcc \
    zlib1g-dev \
    git \
    python \
    python-dev \
    python-pip \
    python3-dev \
    python3-pip \
    python-sphinx \
    python3-sphinx \
    libzmq3-dev \
    sqlite3 \
    libsqlite3-dev \
    pandoc \
    libcurl4-openssl-dev \
    nodejs \
    nodejs-legacy \
    npm

npm install -g less
pip install invoke
```

If any of the above commands fails, switch to root with `sudo -s` and try again.

Now clone the IPython git repo and navigate to its directory:

```bash
git clone --recursive https://github.com/ipython/ipython.git
cd ipython
```

A quick note about pip and Anaconda. Until today I used Anaconda to maintain Python. Anaconda is a great tool, but it adds complexity beyond pip, and my understanding of it is limited. One example: when I wanted to add multiple Python kernels to my notebook, my first attempt consisted of creating a new Anaconda environment for Python 3. Of course, this actually creates a clean environment and requires a new IPython installation. Each IPython won't be able to see the other's installation. Eventually I gave up on Anaconda. I reasoned that I would be able to use `pip` instead. After all, tmpnb doesn't use Anaconda at all.

I'm glad I switched. The following commands will install IPython for both versions of Python:

```bash
pip2 -e install "ipython[all]"
pip3 install "ipython[all]"
```
Here I am not sure whether it is better to use `ipython[notebook]` instead (which is what the IPython dev installation instructions suggest). Kyle's Dockerfile claims that using `-e` with the `[all]` option will cause namespace conflicts.

Time to install the two Python kernels!

```bash
python2 -m IPython kernelspec install-self --system
python3 -m IPython kernelspec install-self --system
```
Now you should be good to go. You can test your two IPython installations by running `iptest2` and `iptest3` from a directory other than `ipython`.

Now that we have IPython working with two Python kernels, it's time to add Julia. Run Julia and update the IJulia package with `Pkg.update("IJulia")`. If no updates were needed, re-build the package with `Pkg.build("IJulia")` (this ensures IJulia is aware of your new IPython installations). The key to adding a Julia kernel to IPython is found in the contents of this [Julia kernel.json file][9]:

```json
{
  "display_name":"Julia",
  "argv":[
    "/usr/bin/julia",
    "-i",
    "-F",
    "/home/jovyan/.julia/v0.3/IJulia/src/kernel.jl",
    "{connection_file}"],
    "language":"julia",
    "codemirror_mode":"julia"}
```
Modify the julia binary path and path to `kernel.jl` to match your own paths to Julia and IJulia, respectively. Then move the `kernel.json` file to the following directory (if any of the folders don't exist, make them):

```bash
/home/jkersulis/.ipython/kernels/julia/

```
You should now have a Julia option in the kernel dropdown of your IPython notebook!

I had the [bash shell][10] working, but it seems to be broken now. I have decided to cut my losses and start getting some research work done. Until next time.  :)

[1]: https://networkx.github.io/
[2]: http://www.graphviz.org/
[3]: https://github.com/numerical-mooc/numerical-mooc
[4]: https://github.com/ipython/ipython
[5]: https://twitter.com/rgbkrk
[6]: tmpnb.org
[7]: https://github.com/ipython/ipython/blob/master/Dockerfile
[8]: https://github.com/jupyter/tmpnb/blob/master/images/demo/Dockerfile
[9]: https://github.com/jupyter/tmpnb/blob/master/images/demo/Julia/kernel.json
[10]: https://github.com/takluyver/bash_kernel
[11]: https://github.com/JuliaLang/IJulia.jl#troubleshooting
