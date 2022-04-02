## Using Numba {#sec:pythonNumba}

The Python package [Numba](https://numba.pydata.org/) provides a JIT compiler for *a subset* of Python and NumPy code.
After installing the package, you can apply simple decorators to annotate Python functions.
These functions will then be compiled to machine code on the fly and then may execute much faster.
Numba has the advantage that it is relatively easy to install and works with pure Python and NumPy.

\rel.code{numbaExample}{An example for annotating a function for compilation with numba.}{numbaExample.py}{}{}{}

We found that this can significantly speed up some of the computations in our [`moptipy`](https://thomasweise.github.io/moptiy) library.
To give a typical example, let us look back at the makespan objective function of the Job Shop Scheduling Problem introduced in [@sec:jsspObjectiveFunction] as [@lst:jssp_makespan]. 
This function takes as input a three-dimensional NumPy array representing a Gantt chart (see []).
[@sec:jssp:gantt]).
It computes the maximum value over all end times of the last operations performed on each machine.
This is a fairly simple task and we represent it in [@lst:numbaExample] again as function `makespan_plain`. 

We can annotate the exactly same function for Numba JIT compilation.
All we have to is to add the line `@numba.njit(nogil=True, cache=True)` right before the function definition.
The annotated function in [@lst:numbaExample] is `makespan_numba`.

|what|measured time|
|--:|--:|
|plain|0.1794|
|numba|0.0297|

: The output of [@lst:numbaExample]. {#tbl:numbaExampleResults}

The results of executing the program are shown in [@tbl:numbaExampleResults].
Even for this very simple example, we can reduce the runtime by about 80%.

When we implement algorithms in Python, it therefore makes sense to explore whether we can achieve speed-ups by applying Numba.
However, at the time of this writing, there also are some limitations:

1. Numba does not apply to object methods, *only* to functions.
   (But this does not need to be a problem, as we see in [@sec:pythonCallingMethodsAndFunctions].)
2. Numba does not allow us to Python objects such as the random number generator from Numpy.
   This is a bit annoying, as this limits us to use Numba only in deterministic subroutines.
