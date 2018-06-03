---
layout: post
title: Time series, JupyterLab, and DataFrames
---

# Time series, JupyterLab, and DataFrames
_Lessons learned while working with time series in Python_

My current project has me working with electric load profiles. The task is to understand these time series well enough to develop metrics, so others can quickly summarize and understand their own load profile data. Here are a few things I learned from the process.

## Pandas is awesome

I cannot imagine doing the past month's work without [Pandas][pandas]. It silently carries a timestamp index through my analysis, keeping everything aligned and making sanity checks easy. When I need to combine datasets, Pandas keeps everything aligned to one index. When I need to resample a time series, `DataFrame.resample` has me covered. My functions can reason from the index, and I can pivot or group the data by any feature. Key-based indexing has eliminated the cognitive burden of integer indexing that characterized my MATLAB days. With an appropriate DataFrame, analysis and visualization become nearly effortless, and I can actually read my code weeks later.

If you have seen DataFrames before but feel overwhelmed or don't get what the big deal is, check out Tom Augspurger's [idiomatic pandas series][datasframe]. He taught me about method chaining, for example, which I use all the time now. Any processing step that operates on a DataFrame can be wrapped in a function; then you can use `DataFrame.pipe` to call several of these processor functions in a chain. Like this:

```python
# normalize_cols and center_cols are
# located in a utilities.py file in my module.
def normalize_cols(df):
    df = df.copy()
    for c in df:
        df[c] = df[c]/df[c].max()
    return df

def center_cols(df):
    df = df.copy()
    for c in df:
        df[c] -= df[c].mean()
    return df

# Normalize and center a DataFrame:
df = (raw_data
        .pipe(normalize_cols)
        .pipe(center_cols)
    )
```

Now suppose I want to repeat the analysis without normalizing the data. I just comment out the `.pipe(normalize_cols)` line, easy. This is like [`compose` in functional programming][adequate]: stuff goes into the chain, and processed stuff comes out the bottom. Clean.

## I was doing Matplotlib wrong
I struggled to make lots of complicated plots. Then I re-read [Anatomy of Matplotlib][aompl]. Then I made more plots and struggled less, and now I finally feel in control. Here's what I do now:

```python
data # dict with all data

# keys for selecting some of the data
keys = ['us_data', 'france_data', 'etc']

# now I declare what I want in each subplot
# by writing a function that fills in one subplot:
def ax_plot_something(ax, ax_data):
    # mess with data to get x and y
    x = ...
    y = ...
    ax.scatter(x, y)

# next, make one subplot for each dataset
fig, axes = plt.subplots(
    len(keys), 1, # one subplot row for each dataset, 1 column
    figsize=1.2*plt.figaspect(0.8), # 0.8 aspect ratio, scaled 120%
    sharey=True # have all subplots share y axis limits
    )

# now loop over the subplot axes and fill everything in
for ax, key in zip(axes.flat, keys): # `flat` is unnecessary here, but often useful
    ax_data = data[key]
    ax_plot_something(ax, ax_data)
    ax.set(...) # axis properties

plt.tight_layout() # make sure nothing overlaps, get ready to print
savefigure('us_france_etc', 'paper')
```

This straightforward approach works for complicated figures. It's easy to change overall structure (aspect ratio, number of subfigures, datasets), as well as subplot details (via `ax_plot_something`).

## [JupyterLab][jupyterlab] is pretty sweet
I was thrilled when I first heard about JupyterLab and saw a prototype demo. I've had it installed since before the [beta release](br), but this is the first project where I really used it. I'm still put off by the missing features: no keyboard shortcut customization,[^editing] no hotkey for hiding or clearing cell output in a notebook, no ipywidgets. But after using it heavily this past week, I finally understand, and it's worth leaving plain old notebooks behind. Here's my setup now:

![]({{ site.baseurl }}images/jupyterlab.png)

I launch JupyterLab from the main project directory. Notebooks and markdown files are in the middle pane, and the right pane is for code files. Any code worth wrapping in a function immediately goes from a notebook in the middle pane to a Python file on the right. I don't even have to switch browser tabs (and there's a [keyboard shortcut][shortcut] to jump between Jupyter Lab panes).

The terminal implementation is also great. I can keep a long computation from locking up my notebook work by opening a new terminal in Jupyter Lab, doing `%run boilerplate.py` (where I keep all my setup code), and pasting in the computationally-intensive code. Then I can monitor the progress without switching tabs or windows.

I'm excited for JupyterLab to get proper keyboard shortcut editing (so I can quickly toggle or clear cell outputs) and widgets (so I can make interactive plots and use the excellent `seaborn.choose_colorbrewer_palette` tool). But even without these features, it's a major go.

## Jupyter notebooks are better left ephemeral

I used to make new Jupyter notebooks like crazy. Some of them were abandoned after a couple cells, while others wound up as interminable streams of intertwined notes and code. Function documentation ended up in markdown cells (bad idea), and quite often I would duplicate code and notes across notebooks (really bad idea). I would of course tweak each new version, so when I went back to older notebooks that used the same names for lesser versions of my functions, the missing features and incompatibility would cause headaches. The long, messy notebook approach also makes it daunting to add new datasets or quickly regenerate figures. Basic things like that should be easy.

So now I don't put code in a notebook if I can put it in a code file instead. Notebooks are great for developing functions, but should almost never store them. Also, I periodically consider whether each notebook could be a plain old markdown file instead, and I export old notebooks as markdown files. This ensures that any useful code ends up in my module, where I can access it any time.

Another bad habit I had was copying long blocks of boilerplate code into the first cell of every notebook. I'm not sure why I did this to myself -- it's my least favorite thing about LaTeX. Now my notebooks have just two lines of code in the first cell, both of them magics:
```python
%matplotlib inline  # get ready to plot
%run boilerplate.py # load all the data and code
```
`boilerplate.py` evolves over time along with my Python code, making older notebooks better automatically the next time I open them.

## Setup is everything

I began this project like every other: without an adequate organization scheme. As I added datasets to the project and code grew more complex, the cognitive burden of getting started in the morning or just regenerating a figure became substantial. It took some effort to go back and organize things properly, but I'm glad I did. Here's what the project looks like now:

### Data
- Datasets are saved as .pkl files (using `pandas.to_pickle`) in one directory for quick recall. Some of the datasets were originally scattered across numerous source files, and reading a .pkl file is faster than running the code that reads the original source. And if I want to share a dataset with someone else on the team, they're getting one file, not a directory full of old Windows-encoded TSVs.
- Data files share one [tidy][tidy] format. This is easy for time series: just align the data columns to a [datetime index][datetime].
- I gave each DataFrame a concise name, a key. Now I load all datasets into one dictionary and index with lists of keys. It's easy to add or remove a dataset to some analysis or figure: just modify the `keys` list at the top.

### Notebooks
- As always, I keep all my notebooks in a `nb` directory under the main project directory. But now I try much harder to write more reusable code, to move that code from notebooks into my module, and to export notebooks into markdown files when I've finished some analysis and moved on.
- No more blocks of boilerplate code in the first cell of every notebook! I keep all setup code in a `boilerplate.py` file now, and use the `%run` magic to run it.

### Code
-All that Python module importing and data loading code I once pasted into the first cell of every notebook has been replaced by `%run boilerplate.py`.
- I'm writing more reusable code, and making sure useful functions end up in Python files where I can recall them without looking for them first.
- I spend more time thinking about figure layout before writing the actual code. When I write a function to fill out each `axes` instance, it's easy to compose that figure type with others later on.

Often it seems that the lessons I learn about workflow fade. Before long I'm back to making the same mistakes. But some of the things I've learned in the past month left an imprint, and I'm more excited about beginning work each day as a result.

[^oof]: https://www.mathworks.com/help/matlab/data_analysis/time-series-objects.html
[^editing]: They technically have a keyboard shortcut editor, but the Jupyter notebook GUI was way better. I couldn't figure out the names of the actions I'm trying to bind, so I gave up. A list of valid actions or some documentation would be most helpful.
[aompl]: https://github.com/matplotlib/AnatomyOfMatplotlib
[datasframe]: http://tomaugspurger.github.io/modern-1-intro
[jupyterlab]: http://jupyterlab.readthedocs.io/en/stable/
[br]: https://blog.jupyter.org/jupyterlab-is-ready-for-users-5a6f039b8906
[adequate]: https://mostly-adequate.gitbooks.io/mostly-adequate-guide/ch05.html
[pandas]: https://pandas.pydata.org/
[tidy]: http://tomaugspurger.github.io/modern-5-tidy
[datetime]: https://pandas.pydata.org/pandas-docs/stable/timeseries.html
[shortcut]: https://jupyterlab.readthedocs.io/en/stable/user/interface.html#keyboard-shortcuts
