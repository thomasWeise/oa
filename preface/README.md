# Preface {-}

After writing *Global Optimization Algorithms &ndash; Theory and Applications*&nbsp;[@WGOEB] during my time as PhD student a long time ago, I now want to write a more practical guide to optimization and metaheuristics.
Currently, this [book](http://thomasweise.github.io/oa/index.html) is in an early stage of development and work-in-progress, so expect many changes.

The text tries to introduce optimization in an accessible way for an audience of undergraduate and graduate students without background in the field.
It tries to provide an intuition about how optimization algorithms work in practice, what things to look for when solving a problem, or how to get from a simple, working, proof-of-concept approach to an efficient solution for a given problem.
We follow a "learning-by-doing" approach by trying to solve one practical optimization problem as example theme throughout the book.
All algorithms are directly implemented and applied to that problem after we introduce them.
This allows us to discuss their strengths and weaknesses based on actual results.
We try to improve the algorithms step-by-step, moving from very simple approaches, which do not work well, to efficient metaheuristics.

We use concrete examples and algorithm implementations written in Python.
All of it is freely available in the repository *[thomasWeise/mopitpy](https://github.com/thomasWeise/moptipy)* on [GitHub](http://www.github.com) under the MIT&nbsp;License.
Each source code listing is accompanied by a *(src)* link in the caption linking to the full version of the file in the GitHub repository.

The text of the book itself is actively written and available in the repository *[thomasWeise/oa](http://github.com/thomasWeise/oa)* on GitHub.
There, you can also submit *[issues](http://github.com/thomasWeise/oa/issues)*, such as change requests, suggestions, errors, typos, or you can inform me that something is unclear, so that I can improve the book.
If you discover an error in any of the examples, please [file an issue](http://github.com/thomasWeise/moptipy/issues).

This book is released under the Attribution-NonCommercial-ShareAlike 4.0 International license (CC&nbsp;BY&#8209;NC&#8209;SA&nbsp;4.0), see <http://creativecommons.org/licenses/by-nc-sa/4.0/> for a summary.
I try to develop it in multiple languages in parallel, but I will probably not be able to keep them synchronized.
English will be the canonical working language with the most up-to-date version.

| &nbsp;
| Prof. Dr. [Thomas Weise](http://iao.hfuu.edu.cn/5)
| Institute of Applied Optimization ([IAO](http://iao.hfuu.edu.cn)),
| School of Artificial Intelligence and Big Data,
| [Hefei University](http://www.hfuu.edu.cn/english/),
| Hefei, Anhui, China.
| Web: <http://iao.hfuu.edu.cn/team/director>
| Email: <tweise@hfuu.edu.cn>, <tweise@ustc.edu.cn>

If you want to cite the book, you can use the following information:

```
@book{oa,
  author    = {Thomas Weise},
  title     = {\meta{title}},
  year      = {\meta{year}},
  publisher = {Institute of Applied Optimization ({IAO}),
               School of Artificial Intelligence and Big Data,
               Hefei University},
  address   = {Hefei, Anhui, China},
  url       = {http://thomasweise.github.io/oa/},
  edition   = {\meta{date}}
}
```
The version information for this book is:

| &nbsp;
| code repository: [\repo{mp}{repo.name}](\repo{mp}{repo.url})
| code commit: \repo{mp}{repo.commit}
| code date: \repo{mp}{repo.date}

