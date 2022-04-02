# Python Programming Tips {#sec:python}

In this book, we explore the wonderful world of optimization algorithms.
We do this from the practical perspective of the programmer.
An we use [Python](https://www.python.org/) as programming language of choice.
We provide lots of Python example codes and even implement all algorithms discussed in this book within a complete system for experimentation and experiment result evaluation, namely our [moptipy](https://thomasweise.github.io/moptipy) framework. 

Now Python is not a fast programming language.
It is much slower than, e.g., `C` or `C++`.
It has the advantage of being easy to read and easy to understand.
It also has the advantage of offering a lot of libraries and packages.
For a student, it also has the advantage that it is widely used in the fields of Artificial Intelligence, meaning that it will probably be used in whichever company you may work on later (and, hence, look good on your CV).
Nevertheless, it is slow indeed.

Throughout our book, we therefore apply some performance tweaks here and there to make the programs run a bit faster.
If we can save a millisecond in some code that its executed a million times, this means we can save a quarter of an hour of runtime.
Here, we provide a short and more or less unstructured list of the tweaks we apply.

\rel.input{numba/README.md}
\rel.input{callingMethodsAndFunctions/README.md}
