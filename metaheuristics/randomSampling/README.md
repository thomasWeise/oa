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
We already learned how to create one such sequence, namely the constant one returned by our `Space` implementation given in [@lst:PermutationsWithRepetitions].
All we need to do to implement the nullary search operator `Op0` (see [@lst:op0]) for the permutations with repetitions is to first copy this constant sequence into the array `dest` and then shuffle it randomly.

\git.code{mp}{Op0Shuffle}{A nullary search operator for permutations with repetitions which creates random sequences.}{moptipy/operators/permutations/op0_shuffle.py}{}{book}{doc,hints,comments}

This trivial implementation is illustrated in [@lst:Op0Shuffle].
While it is not specified how the [`shuffle` method](https://numpy.org/devdocs/reference/random/generated/numpy.random.Generator.shuffle.html) of the [numpy random generator](https://numpy.org/devdocs/reference/random/generator.html) works, I assume that it will apply the Fisher-Yates shuffle algorithm&nbsp;[@FY1948STFBAAMR; @K1969SA].
With this very simple operator, we can now sample points&nbsp;$\sespel$ from the search space&nbsp;$\searchSpace$ uniformly at random.
Since we can convert such points to Gantt charts using our encoding&nbsp;$\encoding$, this means that we can generate random (but feasible!) Gantt charts, too.



### Single Random Sample

#### The Algorithm

Now that we have all ingredients ready, we can test the idea.
In [@lst:SingleRandomSample], we implement this algorithm (here called `1rs`) which creates exactly one random point&nbsp;$\sespel$ in the search space.
It then takes this point and passes it to the [evaluation](https://thomasweise.github.io/moptipy/moptipy.api.html#moptipy.api.process.Process.evaluate) function of our black-box [`process`](https://thomasweise.github.io/moptipy/moptipy.api.html#moptipy.api.process.Process), which will perform the decoding&nbsp;$\solspel=\encoding(\sespel)$ and compute the objective value&nbsp;$\objf(\solspel)$.
Internally, we implemented this function in such a way that it automatically remembers the best candidate solution it ever has evaluated.
Thus, we do not need to take care of this in our algorithm, which makes the implementation so short.

\git.code{mp}{SingleRandomSample}{An excerpt of the implementation of an algorithm which creates a single random candidate solution.}{moptipy/algorithms/single_random_sample.py}{}{book}{}


#### Results on the JSSP

Of course, since the algorithm is *randomized*, it may give us a different result every time we run it.
In order to understand what kind of solution qualities we can expect, we hence have to run it a couple of times and compute result statistics.
We therefore execute our program [23&nbsp;times](https://thomasweise.github.io/moptipy/moptipy.examples.jssp.html#moptipy.examples.jssp.experiment.EXPERIMENT_RUNS).
At this point, I suggest to read [@sec:statisticalMeasures], where we describes which statistical measures exist to summarize experimental results.

\rel.input{end_results_1rs.md}

: The results of the single random sample algorithm&nbsp;`1rs` for each instance $\instance$ in comparison to the lower bound&nbsp;$\lowerBound(\objf)$ of the makespan&nbsp;$\objf$ over 23&nbsp;runs: the best and mean result quality and its standard deviation ($\minBestF$, $\meanBestF$, $\stddevBestF$), the mean of the scaled result quality and the mean time until a run was finished ($\meanBestFscaled$, $\meanTotalMS$). The summary line presents the best, geometric mean, worst, and standard deviation of the scaled result quality over all runs on all instances ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$), as well as the geometric mean of the total runtimes ($\geomeanTotalMS$). See [@sec:statisticalMetrics] for more details. {#tbl:singleRandomSampleJSSP}

[@tbl:singleRandomSampleJSSP] lists the summary statistics of this little experiment.
These statistics are described in [@sec:statisticalMetrics] in detail.

From the table, we find that the best results ($\minBestF$) of any run on any instances are often much worse than theoretically best makespans, i.e., the lower bounds&nbsp;$\lowerBound(\objf)$ of the objective functions&nbsp;$\objf$.
The arithmetic mean end result qualities ($\meanBestF$) are even worse.
We obtain the *scaled* end result qualities by dividing the best objective values of each run by the lower bounds of the objective function.
The arithmetic means $\meanBestFscaled$ of these values tend to be around&nbsp;2, meaning that our `1rs` algorithm delivers Gantt charts which tend to have a makespan twice as long as what could theoretically be possible.
The standard deviation&nbsp;$\stddevBestF$ of the best result qualities is also relatively large, indicating that different executions ("runs") of the `1rs` algorithm have results that largely differ in quality.
