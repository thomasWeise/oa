## Search Operators {#sec:searchOperators}

One of the most important design choices of a metaheuristic optimization algorithm are the search operators employed.


### Definitions

\definition{def}{searchOp}{An $k$-ary *search operator*&nbsp;$\searchOp:\searchSpace^k\times\random\mapsto\searchSpace$ is a left-total function which accepts $k$&nbsp;points in the search space&nbsp;$\searchSpace$ (and a source&nbsp;$\random$ of randomness) as input and returns one point in the search space as output.}

Special cases of search operators are

- nullary operators ($k=0$, see [@lst:op0] sample a new point from the search space without using any information from an existing points,
- unary operators ($k=1$, see [@lst:op1]) sample a new point from the search space based on the information of one existing point,
- binary operators ($k=2$, see [@lst:op2]) sample a new point from the search space by combining information from two existing points, and


### A Programmer's Perspective

If we look at this again from the perspective of the programmer, we can define a few very simple API components.

\git.code{mp}{op0}{An abstract base class for nullary search operators.}{moptipy/api/operators.py}{}{op0}{doc,hints}

\git.code{mp}{op1}{An abstract base class for unary search operators.}{moptipy/api/operators.py}{}{op1}{doc,hints}

\git.code{mp}{op2}{An abstract base class for binary search operators.}{moptipy/api/operators.py}{}{op2}{doc,hints}

Whether, which, and how such such operators are used depends on the nature of the optimization algorithms and will be discussed later on.

Search operators are often *randomized*, which means invoking the same operator with the same input multiple times may yield different results.
In the definitions, this is signified by the component&nbsp;$\random$ in their input.
Therefore [@lst:op0;@lst:op1;@lst:op2] all expect an instance of [`Generator`](https://numpy.org/devdocs/reference/random/generator.html), a pseudorandom number generator of the [numpy](https://numpy.org/) library, as parameter.

Operators that take existing points in the search space as input tend to sample new points which, in some sort, are similar to their inputs.
They allow us to define proximity-based relationships over the search space, such as the common concept of neighborhoods.

\definition{def}{neighborhood}{A unary operator&nbsp;$\searchOp:\searchSpace\times\random\mapsto\searchSpace$ defines a *neighborhood* relationship over a search space where a point&nbsp;$\sespel_1\in\searchSpace$ is called a *neighbor* of a point&nbsp;$\sespel_2\in\searchSpace$ if and only if&nbsp;$\sespel_1$ could be the result of an application of&nbsp;$\searchOp$ to&nbsp;$\sespel_2$.}


### Example: Job Shop Scheduling

We will step-by-step introduce the concepts of nullary, unary, and binary search operators in the subsections of [@sec:metaheuristics] on metaheuristics as they come.
This makes more sense from a didactic perspective.
