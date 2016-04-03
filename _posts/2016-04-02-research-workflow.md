# A research workflow
*Jonas Kersulis*

##  What is research?
If you suddenly disappear (read: graduate), would a newcomer understand the work you've done?

Well, what would that work consist of?

* Technical/communication work
    * Scratch notes
    * Semi-formal documentation
    * Research papers
    * Posters
    * Presentations
* Practical work
    * Source code
    * Input data for code to work on
    * Scripts for running code on data
    * Output from code execution
    * Figures to help interpret results

These categories are distinct yet often inseparable. A script file may load data, call source code to generate output, and generate a figure for inclusion in a research paper. The pieces must be kept organized and together.

## Organization
Here's a master directory for a project I've been working on:

```
temporal-instanton/
```

Now give each type of research output a place:

```
temporal-instanton/
    nb/
    src/
    data/
    images/
    papers/
    posters/
    presentations/
```

Let's look at each directory. 

### Notebook directory: `nb/`
Here is the February portion of my notebook directory:

```
nb/
    2016-02-03-change-line-data-input.ipynb
    2016-02-04-updating-figures.ipynb
    2016-02-05-normalized-performance-figure.ipynb
    2016-02-09-abstraction.ipynb
    2016-02-10-new-interface.md
    2016-02-18-clean-start.md
    2016-02-22-parametric-analysis.ipynb
    2016-02-22-translation-revisited.ipynb
    report-2016-01-19.ipynb
```

Each file is a [Jupyter notebook][1]. The naming scheme ensures the most recent notebook is always at the bottom (reports being the exception). I make the file names as long as they need to be to ensure I can reliably guess their contents a few months later. Each notebook whose name begins with a date represents work on a particular feature or exploration of a certain topic. The contents are flexible -- some notebooks are heavy on written documentation, others contain only code, and still others contain a little of everything. I create`report-` notebooks less frequently; they contain semi-formal documentation that summarizes several scratch work notebooks. Report notebooks are often created to be shared with my advisor, and pieces of them tend to make it to research papers.

### Source code directory: `src/`
`src/` contains all source code. Mine is a little cluttered right now, but here's what I wish it looked like:

```
src/
    TemporalInstanton.jl
    dataload.jl
    solvetmpinst.jl
    matrixbuilding.jl
    manipulations.jl
    plot.jl
    powerflow.jl
    thermalmodel.jl
```

Without going into painful detail about the handful of files here, I'll just mention the role each plays. `TemporalInstanton.jl` defines a Julia module, making it easy to load all the other code with one command. `dataload.jl` contains functions used to translate raw data (from, say, [MatpowerCases][2]) into input my algorithm can accept. `solvetmpinst.jl` contains those functions that implement the actual algorithm (these are kept outside `TemporalInstanton.jl` to keep that file brief and easier to read). `matrixbuilding.jl` contains functions that turn input data (mostly vectors) into matrices defining an instance of a quadratically-constrained quadratic program. `plot.jl` is self explanatory. `powerflow.jl` contains functions used to process input and output data to interpret them in terms of injections and flows. `thermalmodel.jl` does the same thing for transmission line temperatures.

One key benefit of developing all source code in one directory is version control. You can use git to track changes to your code and push everything to a remote ([here's][3] a good remote option for umich students). Every time you get important results or generate a useful plot, you can record the most recent commit hash. Later on you can reproduce your results by returning to that commit.

### Data directory: `data/`
My `data/` directory is kind of cluttered, but that's also its purpose. Keeping an algorithm implementation separate from data used to test it is essential for code reuse and portability. An important tip in the context of `data/`: strive to use plaintext rather than binary files wherever possible. A .csv or .txt file is better than a .jld or .mat file. It is to your great credit if someone else can inspect and understand your datasets using just a text editor, without firing up Julia or MATLAB.


### Images directory: `images/`
So yeah, I put all the images here. When the time comes to polish and image and include it in a paper, poster, or presentation, I copy it to that paper's directory, which brings me to the remaining three directories.

### Papers, posters, and presentations
Each paper, poster, or presentation I produce in conjunction with a particular project gets its own folder. Each of these folders is self-contained so I can transfer everything needed to regenerate or modify a paper or presentation (including .tex files, images, etc.) by copying one directory. I nest these folders in directories called `papers/`, `posters/`, and `presentations/`.

Here are the contents of my `papers/` directory:

```
papers/
    conference-powertech
    journal-transactions-power-systems
```

The contents of `journal` and `conference` are pretty typical of LaTeX directories. There are .tex and .bib files, a folder for images, and all those silly auxiliary files LaTeX really shouldn't generate but does anyway just to bother us. `posters/` and `presentations/` are similarly self-explanatory.

## Software tools
I've discussed how to keep files organized, but what about creating and editing them? There are hundreds of tools out there, and I've tried more than my fair share. I want to talk about four that satisfy the following criteria:

* Cross-platform.
* Stable.
* Free and open source.

### Jupyter notebook
The Jupyter notebook is a tool for interlacing code, code output, and documentation (including typeset math). This is the best tool I know of for keeping a lab notebook. It's not mature yet (only a couple years old in its current form), but it is stable. 

A few things I love about Jupyter:

* Interface. Jupyter has an intuitive cell layout. Each cell can contain Markdown (for prose, typeset math, and prettily-formatted code), or code written in any language. Code cells can be evaluated, and any output (text, plots, whatever), shows up inline and stays in the notebook file.
* Language-agnostick. As I just mentioned, Jupyter doesn't care what language you work with. You can execute Python code, switch to Matlab to run a Matlab cell, and jump right back. It's seamless.
* Export to PDF. Nothing is trapped in a Jupyter notebook. It's rendered as a webpage, so you can just print it with Ctrl+p. You can also export the Markdown, the code, or translate the whole notebook to LaTeX.

Get started with Jupyter [here][7].

### TeXstudio
TeXstudio is a LaTeX editing environment with drag-and-drop, autocomplete, bidirectional sync, and an integrated PDF viewer. It was developed by PhD students who were unsatisfied with other popular LaTeX environments. Here are a few of the things I like about it:

* Interface. It has everything you'd expect to make editing LaTeX easy. You can jump around between sections, browse symbols and click to insert one, keep the compiled PDF open alongside the source, and jump between source and PDF easily.
* Macros. TeXstudio has a simple macro-writing syntax. Example: you can set it up so that when you type "hw<TAB>", TeXstudio inserts a homework template. This makes it easy to quickly start a new a homework document.
* Autocomplete environments and references. Typing "\begin{" will cause a list of environments to pop up. The list narrows as you type, so you can quickly insert, say, an `align` environment with fewer keystrokes. The same thing works for "\cite{" and "\ref{" -- TeXstudio knows about all your bibliography entries and equations and labels, so you do less typing.

Head [here][6] to download TeXstudio.

### Atom
Atom is free text editor commissioned by GitHub. It's written in HTML, CSS, and JavaScript -- basically it's a web browser acting as a text editor. Atom is stable, fast (as of the 1.0 release), and widely used. There are tons of [packages][4] available.

Three of the things I like most about Atom are:

* Search tags. This feature integrates with ctags. You can press Ctrl+r to search through all tags in the current file or Ctrl+Shift+r to search through all tags in the current directory. If every function and type has an associated tag, this makes it easy to jump around in your source code with barely a thought. Searching is fuzzy, too, so you can get great results just by typing a few letters.
* Search commands. The same fuzzy search ability is available for all of Atom's commands. You can press Ctrl+Shift+p to open the command palette and search through all available commands from all installed packages.
* Multi-cursor. Ctrl+click anywhere to add a cursor. Highlight a block of text and press Ctrl+Shift+l to place a cursor on each line. Highlight a term and use Ctrl+d to highlight other instances of that term, placing a cursor at each one. This makes it easy to, say, wrap a bunch of words in double-quotes in seconds, with barely any cognitive burden.

You can get started by downloading Atom [here][5].

### Git
Git is the version control software of choice for Linux kernel development, major tech companies, ten million [GitHub][8] users, etc. It's stable and mature.

Git is notoriously opaque, but the philosophy behind it is simple enough. When you initialize Git in a folder, every file and folder you create in it has a hash. Every change you make also has a hash. So every project state has a hash, and Git holds all of them. This means you can go back to any project state later on.

Why is this helpful? Suppose you profile your code, then make a month's worth of changes and profile again. Suppose the new version of your code inexplicably performs worse than before. With Git, you can quickly get a summary of all the changes you made. You can rewind to a week ago, two weeks ago, and so on until you figure out which change introduced the problem.

Get started with Git [here][9]. (University of Michigan students can get free private repos [here][10].) 

[1]: https://jupyter.org/ 
[2]: https://github.com/kersulis/MatpowerCases.jl 
[3]: https://gitlab.eecs.umich.edu/users/sign_in 
[4]: https://atom.io/packages 
[5]: https://atom.io/
[6]: http://www.texstudio.org/#download
[7]: https://jupyter.org/
[8]: https://github.com/home
[9]: https://git-scm.com/downloads
[10]: https://gitlab.eecs.umich.edu/
