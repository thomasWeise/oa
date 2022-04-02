## Random Sampling {#sec:randomSampling}

If we have our optimization problem and its components properly defined according to [@sec:structure], then we already have the proper tools to solve the problem.
We know

- how a solution can internally be represented as "point"&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ ([@sec:searchSpace]),
- how we can map such a point&nbsp;$\sespel\in\searchSpace$ to a candidate solution&nbsp;$\solspel$ in the solution space&nbsp;$\solutionSpace$ ([@sec:solutionSpace]) via the representation mapping&nbsp;$\encoding:\searchSpace\mapsto\solutionSpace$ ([@sec:searchSpace]), and
- how to rate a candidate solution&nbsp;$\solspel\in\solutionSpace$ with the objective function&nbsp;$\objf$ ([@sec:objectiveFunction]).

The only question left for us to answer is how to "create" a point&nbsp;$\sespel$ in the search space.
We can then apply&nbsp;$\encoding(\sespel)$ and get a candidate solution&nbsp;$\solspel$ whose quality we can assess via&nbsp;$\objf(\solspel)$.
Let us look at the problem as a black box ([@sec:blackbox]).
In other words, we do not really know structures and features "make" a candidate solution good.
Hence, we do not know how to intentionally "create" a good solution in a targeted fashion either.
Then the best we can do is just create the solutions randomly.


### Ingredient: Nullary Search Operation for the JSSP

We can do this by implementing a so-called nullary search operation, whose blueprint was shown in [@lst:op0].
A nullary search operator receives as input a random number generator&nbsp;$\random$ and a container to fill in a new point in the search space.
To implement such an operator, recall that our encoding represents solutions as permutations with repetitions ([@sec:jsspSearchSpace]).
This requires that each job index&nbsp;$\jsspJobIndex\in\intRange{0}{(\jsspJobs-1)}$ of the&nbsp;$\jsspJobs$ must occur exactly&nbsp;$\jsspMachines$ times in the integer array of length&nbsp;$\jsspMachines*\jsspJobs$, where&nbsp;$\jsspMachines$ is the number of machines in the JSSP instance.
We already learned how to create one such sequence, namely the constant one returned by out `Space` implementation given in [@lst:PermutationsWithRepetitions].
All we need to do to implement the nullary search operator `Op0` (see [@lst:op0]) for the permutations with repetitions is to first copy this constant sequence into the array `dest` and then shuffle it randomly.

\git.code{mp}{Op0Shuffle}{A nullary search operator for permutations with repetitions which creates random sequences.}{moptipy/operators/permutations/op0_shuffle.py}{}{book}{doc,hints,comments}

This trivial implementation is illustrated in [@lst:Op0Shuffle].
While it is not specified how the [`shuffle` method](https://numpy.org/devdocs/reference/random/generated/numpy.random.Generator.shuffle.html) of the [numpy random generator](https://numpy.org/devdocs/reference/random/generator.html) works, I assume that it will apply the Fisher-Yates shuffle algorithm&nbsp;[@FY1948STFBAAMR; @K1969SA].
With this very simple operator, we can now sample points&nbsp;$\sespel$ from the search space&nbsp;$\searchSpace$ uniformly at random.
Since we can convert such points to Gantt charts using our encoding&nbsp;$\encoding$, this means that we can generate random (but feasible!) Gantt charts, too.
