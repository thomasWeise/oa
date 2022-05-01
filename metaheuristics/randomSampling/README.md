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

\git.code{mp}{SingleRandomSample}{An excerpt of the implementation of an algorithm which creates a single random candidate solution.}{moptipy/algorithms/single_random_sample.py}{}{book}{comments}


#### Results on the JSSP

Of course, since the algorithm is *randomized*, it may give us a different result every time we run it.
In order to understand what kind of solution qualities we can expect, we hence have to run it a couple of times and compute result statistics.
We therefore execute our program [23&nbsp;times](https://thomasweise.github.io/moptipy/moptipy.examples.jssp.html#moptipy.examples.jssp.experiment.EXPERIMENT_RUNS).
[@tbl:singleRandomSampleJSSP] lists the summary statistics of this little experiment.
All its statistics used are described in detail in [@sec:statisticalMetrics].
At this point, I also suggest to read [@sec:statisticalMeasures], where we describe which statistical measures exist to summarize experimental results as well as their benefits and drawbacks.
Here, we use four types of simple statistics, namely:

1. The minimum and maximum denote best and worst results.
2. Arithmetic means represent average results (see \def.ref{arithmeticMean}).
3. Standard deviations give an impression of how far the results are spread (due to the randomization) from the mean, as described in [@sec:varStdDevQuantiles].
4. The geometric means are used to average results that are scaled with different factors, as described in [@sec:geometricMean].   


\rel.input{end_results_1rs.md}

: The results of the single random sample algorithm&nbsp;`1rs` for each instance&nbsp;$\instance$ with 23&nbsp;runs per instance, in comparison to the lower bound&nbsp;$\lowerBound(\objf)$ of the makespan&nbsp;$\objf$: the best and mean result quality and its standard deviation ($\minBestF$, $\meanBestF$, $\stddevBestF$), the mean of the scaled result quality and the mean time until a run was finished ($\meanBestFscaled$, $\meanTotalMS$). The summary line at the bottom presents the best, geometric mean, worst, and standard deviation of the scaled result quality over all runs on all instances ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$), as well as the mean of the total runtimes ($\meanTotalMS$). See [@sec:statisticalMetrics] for more details. {#tbl:singleRandomSampleJSSP}


From the table, we find that the best results ($\minBestF$) of any run on any instances are often much worse than theoretically best makespans, i.e., the lower bounds&nbsp;$\lowerBound(\objf)$ of the objective functions&nbsp;$\objf$.
For the smallest-scale instance, `orb06`, the optimal makespan is&nbsp;1'010.
The best of the 23&nbsp;runs of `1rs`, however, finds a schedule with a makespan of&nbsp;1'656 (illustrated by statistic&nbsp;$\minBestF$).
On `dmu67`, the lower bound of the objective function is&nbsp;5'589, but the best solution discovered by any run of `1rs` has a makespan of&nbsp;12'818.
The arithmetic mean end result qualities ($\meanBestF$) are even worse.
On `orb06`, this average result is&nbsp;1'932 and on `dmu67`, it is&nbsp;14'150.
We obtain the *scaled* end result qualities ($\meanBestFscaled$) by dividing the end result objective values of each run by the lower bounds of the objective function.
On `orb06`, this is&nbsp;1.913, meaning that in average, `1rs` gives us tours about 91% longer than necessary.
For `dmu67`, with $\meanBestFscaled=2.532$ the average tours are two and a half times as long as the theoretical optima. 
The standard deviations&nbsp;($\stddevBestF$) of the result qualities is also relatively large for all instances.
This indicates that different executions ("runs") of the `1rs` algorithm have results that largely differ in quality.

Let us take a look at the summary statistics over all JSSP instances at the bottom of the table.
First, the minimum&nbsp;$\minBestFscaled$ of the scaled results shows us that no run of the `1rs` algorithm on any of the JSSP instances could provide a schedule with a makespan less than 64% longer than the theoretical optimum.
The geometric mean&nbsp;$\geomeanBestFscaled$ of the scaled end results is&nbsp;2.143, meaning that the average schedule produced by `1rs` is more than twice as long as necessary.
The worst scaled results, $\maxBestFscaled$, even&nbsp;2.721 times as long as the lower bound.
The standard deviation of the scaled results is&nbsp;0.239, which is more than 10% of the geometric mean.


\rel.figure{makespan_scaled_1rs}{Violin plots overlaid with box plots to illustrate the distributions of the (scaled) makespans achieved by `1rs` on the different JSSP instances.}{makespan_scaled_1rs.svgz}{width=99.9%}


In [@fig:makespan_scaled_1rs] we visualize how the results of the single runs of our `1rs` algorithm are distributed for the different problem instances.
We therefore sort the instances based on the size of their search space (see [@tbl:jsspSearchSpaceTable]) and, for each instance, draw a [violin plot](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.violinplot.html) overlaid with a [box plot](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.boxplot.html) of the scaled result qualities.
From the box plots, we can see

- the median (the line in the middle, see also [@sec:meanAndMedian]),
- the 25% and 75% quantiles (the upper and lower end of the boxes, see also [@sec:varStdDevQuantiles]),
- the arithmetic mean (triangle symbol),
- the 5% and 95% quantiles (horizontal whisker lines at bottom and top),
- the outliers, i.e., data elements outside of the whiskers, as circles, and
- the 95% confidence intervals for the median (as notches in the boxes).

The violin plots in the background show us the approximate distribution of the data points.
They are the wider around the horizontal axis the more often the corresponding scaled result qualities were observed in the runs on the instance.
What we immediately see from these plots is that the larger the search space for a JSSP instance gets, the worst `1rs` tends to deliver.
One visible exception is instance `ta70`, which is quite large but seems to be easier than most other instances.

Finally, in [@fig:gantt_1rs], we plot the Gantt charts with the median makespan delivered by the runs of the&nbsp;`1rs` algorithm on each instance (see [@sec:meanAndMedian] regarding what the median is).
In other words, we sort the 23 Gantt charts we obtained on each instance by their makespan.
Then we plot the one in the middle of this sorted list.

In each Gantt chart, we can find a lot of empty space between the operations.
This means that when an operation is assigned to a machine, it first needs to wait some time before it can be executed.
This is because the predecessor operations of the same job are not yet finished on other machines.
A lot of time is wasted.

We also present the lower bounds of the makespans as vertical lines in the charts.
We can clearly see that the Gantt charts tend to need much longer than that (theoretical) optimal solutions to complete.

As a side note:
The Gantt charts also reveal the partitioned structure of `dmu67`, `dmu72`, and `swv14`, where the jobs first need to pass through on half of the machines before being processed by the other half (see [@sec:jsspBenchmarkInstances]).


\rel.figure{gantt_1rs}{Gantt charts of the median results delivered by `1rs`.}{gantt_1rs.svgz}{width=99.9%}


In summary, we clearly see that `1rs` does not produce good results.
This is completely reasonable.
After all, we just create a single random solution.
We can hardly assume that doing all jobs of a JSSP in a random order would be good idea.

But we also notice more.
Let's go back to [@tbl:singleRandomSampleJSSP].
The mean time $\meanTotalMS$ until the runs stop improving is approximately&nbsp;1ms.
The reason is that we only perform one single objective function evaluation per run, i.e., 1&nbsp;FE.
Creating, mapping, and evaluating a solution can be very fast.
However, we had originally planned to use up to two minutes for optimization.
Hence, almost all of our time budget remains unused.

We also find that on `orb06`, the arithmetic mean solution quality $\meanBestF$ (1'932) is 17% longer than the best obtained one ($\minBestF=1'656$).
On `swv14`, the difference is about 6% and in geometric mean, it is&nbsp;12%.
The standard deviation&nbsp;$\stddevBestF$ of the solution quality also is always above 100&nbsp;time units of makespan.
For each JSSP instance, we create 23&nbsp;random solutions.
And these random solutions differ quite a lot in their quality. 
So why don't we try to make use of this variance and the high speed of solution creation?


### Random Sampling Algorithm  {#sec:randomSamplingAlgo}

\definition{rule}{exploitVariance}{If there is a significant variance in the results of an algorithm and we have sufficient computational resources to execute it multiple times, then multiple executions (in parallel or sequential) can be used to improve the expected result quality.}


#### The Algorithm

The random sampling algorithm, also called random search, repeats creating random solutions until the computational budget is exhausted&nbsp;[@S2003ITSSAO].
It basically applies \def.ref{exploitVariance} to `1rs`.
In our corresponding Python implementation given in [@lst:RandomSampling], we therefore only needed to add a loop around the code from the single random sampling algorithm from [@lst:SingleRandomSample].


\git.code{mp}{RandomSampling}{An excerpt of the implementation of the random sampling algorithm which keeps creating random candidate solutions and remembers the best encountered on until the computational budget is exhausted.}{moptipy/algorithms/random_sampling.py}{}{book}{comments}


This algorithm can be described as follows:

1. Set the best-so-far objective value&nbsp;$\obspel$ to&nbsp;$+\infty$ and the best-so-far candidate solution&nbsp;$\solspel$ to&nbsp;`None`. 
2. Create a random point&nbsp;$\sespel'$ in the search space&nbsp;$\searchSpace$ by using the nullary search operator.
3. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the encoding&nbsp;$\solspel'=\encoding(\sespel')$.
4. Compute the objective value&nbsp;$\obspel'$ of&nbsp;$\solspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
5. If&nbsp;$\obspel'$ is better than best-so-far-objective value&nbsp;$\obspel$, i.e., $\obspel'<\obspel$, then
    a. store&nbsp;$\obspel'$&nbsp;in&nbsp;$\obspel$ and
    b. store&nbsp;$\solspel'$&nbsp;in&nbsp;$\solspel$.
6. If the termination criterion is not met, return to *step&nbsp;2*.
7. Return the best-so-far objective value&nbsp;$\obspel$ and the best solution&nbsp;$\solspel$ to the user.

In the actual program code in [@lst:RandomSampling], *steps&nbsp;3 to&nbsp;5* can again be encapsulate by a [wrapper](https://thomasweise.github.io/moptipy/moptipy.api.html#moptipy.api.process.Process.evaluate) around the objective function:
Our the black-box [`process`](https://thomasweise.github.io/moptipy/moptipy.api.html#moptipy.api.process.Process) API discussed in [@sec:blackBoxProcessAPI] both remembers the best-so-far solution *and* internally performs the decoding of points in the search space to candidate solutions if necessary.
This reduces a lot of potential programming mistakes and makes the code much shorter.


#### Results on the JSSP

Let us now compare the performance of this iterated random sampling with our initial method.
[@tbl:randomSamplingJSSP] shows us that the iterated random sampling algorithm is better in virtually all relevant aspects than the single random sampling method.
Its best and mean result qualities are significantly better.
Indeed, the overall best scaled result&nbsp;$\minBestFscaled$ discovered by *any* run of&nbsp;`1rs` is worse than the geometric mean $\geomeanBestFscaled$ of the best scaled result over *all* runs of&nbsp;`rs`.

Performing "1&nbsp;FE" means to create one candidate solution and to evaluate it with the objective function.
The metric&nbsp;$\meanFEsMS$ is the average number FEs that we performed in every single millisecond in our experiments.
It ranges from about&nbsp;110 on the smallest problem instance (`orb06`) to 28.9 on the largest one (`ta70`).
This means that even on the very largest of our problem instances, we can evaluate more solutions per millisecond of a single run of `rs` than in all of our 23&nbsp;runs of the `1rs`.
Since each execution of the algorithm takes 2&nbsp;minutes = 120'000&nbsp;ms, this means that `rs` samples more than 3'470'000&nbsp;solutions per run &ndash; and returns the best one of it.

By remembering the best of millions of created solutions, what we effectively do is we exploit the variance of the quality of the random solutions.
As a result, the standard deviation of the results becomes lower on each instance.
This means that this algorithm has a more reliable performance, we are more likely to get results close to the mean performance when we use&nbsp;`rs` compared to&nbsp;`1rs`.

Actually, if we would have infinite time for each run (instead of two minutes), then each run would eventually guess the optimal solutions.
The variance would become zero and the mean and best solution would all converge to this global optimum.
Alas, we only have two minutes, so we are still far from this goal.


\rel.input{end_results_rs.md}

: The results of the single random sample algorithm&nbsp;`1rs` and the random sampling algorithm&nbsp;`rs` for each instance $\instance$ with 23&nbsp;runs per algorithm/instance combination. See [@sec:statisticalMetrics] for more details. {#tbl:andomSamplingJSSP}


Over all problem instances, the standard deviation&nbsp;$\stddevBestFscaled$ of the scaled result quality of&nbsp;`rs` is slightly higher than of&nbsp;`1rs`. 
The reason for is just that some problem instances are easier than others.


\rel.figure{makespan_scaled_rs}{Violin plots overlaid with box plots to illustrate the distributions of the (scaled) makespans achieved by `1rs` and `rs` on the different JSSP instances.}{makespan_scaled_rs.svgz}{width=99.9%}


[@fig:makespan_scaled_rs] shows again the violin plots overlaid with box plots of the scaled results of our algorithms on the JSSP.
On every single instance, the worst solution discovered by `rs` is much better than the best solution found by `1rs`.

The problem instances are again sorted by the size of their corresponding search spaces.
We can again clearly observe that larger search spaces lead to worse scaled results.
At least one of the reasons for this was already clear from the $\meanFEsMS$&nbsp;metric presented [@tbl:andomSamplingJSSP]:
Larger instances mean slower FEs, which means a smaller total number of generated solutions.

If we compare the Gantt charts of the median runs of `rs` sketched [@fig:gantt_rs] with those of `1rs` in [@fig:gantt_1rs], we can observe a clear reduction of the space between the operations.
While the schedules are still far longer than the lower bounds, they are significantly better than before. 

So far, we have focused only on end-of-run statistics, such as the mean end result quality.
Let us now plot the progress that `rs` makes over time.
In [@fig:progress_rs], we visualize the arithmetic mean of the best-so-far objective value achieved at each point in time during over the 23&nbsp;runs.
We find that on all JSSP instances, the most progress is made during the first 20&nbsp;seconds of the runs.
After about one minute of runtime, the improvements get smaller and less frequent. 


\rel.figure{gantt_rs}{Gantt charts of the median results delivered by `rs`.}{gantt_rs.svgz}{width=99.9%}

\rel.figure{progress_rs}{The arithmetic mean of the best-so-far solution quality of `rs` over time.}{progress_rs.svgz}{width=99.9%}

\rel.figure{progress_rs_log_T}{The arithmetic mean of the best-so-far solution quality of `rs` over time (with log-scaled time axis).}{progress_rs_log_T.svgz}{width=99.9%}


[@fig:progress_rs_log_T] shows the same statistic, but plotted over a logarithmically scaled time axis.
From these diagrams we find that the solution quality improves in the first 100&nbsp;milliseconds of the runs about as same as much as in the remaining 119'900&nbsp;milliseconds.

This is the first time we witness a manifestation of a very basic law in optimization.
When trying to solve a problem, we need to invest resources, be it software development effort, research effort, computational budget, or expenditure for hardware, etc.
If you invest a certain amount&nbsp;$a$ of one of these resources, you may be lucky to improve the solution quality that you can get by, say, $b$&nbsp;units.
Investing&nbsp;$2a$ of the resources, however, will rarely lead to an improvement by $2b$&nbsp;units.
Instead, the improvements will become smaller and smaller the more you invest.
This is exactly the *Law of Diminishing Returns*&nbsp;[@SN2001M] known from the field of economics.

And this makes a lot of sense here.
On one hand, the maximal possible improvement of the solution quality is bounded by the global optimum &ndash; once we have obtained it, we cannot improve the quality further, even if we invest infinitely much of an resource.
On the other hand, in most practical problems, the amount of solutions that have a certain quality gets the smaller the closer said quality is to the optimal one.
This is actually what we see in [@fig:progress_rs_log_T]: The chance of randomly guessing a solution of quality&nbsp;$F$ becomes the smaller the better (smaller)&nbsp;$F$ is.


\definition{rule}{diminishingReturns}{Optimization algorithms make most of their progress early during the search. Eventually, the improvements upon the best-so-far solution will become smaller and require (often exponentially) more runtime.}


From the diagrams we can also see that random sampling is not a good method to solve the JSSP.
It will not matter very much if we have two minutes, six minutes, or one hour.
In the end, the improvements we would get by investing more time would probably become smaller and the amount of time we need to invest to get any improvement would keep to increase.
The progress curves begin to flatten even under the logarithmic scaling of [@fig:progress_rs_log_T], meaning that the algorithm will probably need exponentially more time to find improvements the longer it runs. 
The fact that random sampling can be parallelized perfectly does not help much here, as we would need to provide an exponentially increasing number of processors to keep improving the solution quality.
 

### Summary

With random sampling, we now have a very primitive way to tackle optimization problems.
In each step, the algorithm generates a new, entirely random candidate solution.
It remembers the best solution that it encounters and, after its computational budget is exhausted, returns it to the user.

Obviously, this algorithm cannot be very efficient.
But we already also learned one method to improve the result quality and reliability of optimization methods: restarts.
According to \def.ref{exploitVariance}, restarting an optimization can be beneficial if the following conditions are met:

1. If we have a budget limitation, then most of the improvements made by the algorithm must happen early during the run.
   If the algorithm already uses its budget well can keep improving even close to its end, then it makes no sense to stop and restart.
   The budget must be large enough so that multiple runs of the algorithm can complete or at least deliver reasonable results.
2. Different runs of the algorithm must generate results of different quality.
   A restarted algorithm is still *the same* algorithm.
   It just exploits this variance, i.e., we will get something close to the best result of multiple runs.
   If the different runs deliver bad results anyway, doing multiple runs will not solve the problem.

Above we said that random sampling is not a very efficient algorithm.
This is true in most reasonable scenarios.
In problems where information about existing good solutions does not help us in any way to find new good solutions, we cannot really do better than random sampling.
In most reasonable problems that one may try to solve, however, such information is helpful.
Random sampling then is also a basic yardstick: 
An optimization algorithm that does not significantly outperform random sampling is useless.
