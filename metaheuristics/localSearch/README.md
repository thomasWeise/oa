## Simple Local Searches

Our first algorithm, random sampling, is not very efficient.
It does not make any use of the information it "sees" during the optimization process.
Each search step consists of creating an entirely new and entirely random candidate solution.
Each search step is thus independent of all prior steps.
If the problem that we try to solve is *entirely without structure*, then this is already the best we can do.
But our JSSP problem is not without structure.
For example, we can assume that if we swap the last two jobs in a schedule, the makespan of the resulting new schedule should still be somewhat similar to the one of the original plan. 
Actually, most reasonable optimization problems have a lot of structure.
They usually exhibit *causality*&nbsp;[@R1973ES; @R1994ES; @WCT2012EOPABT; @WZCN2009WIOD]:

\definition{def}{causality}{An optimization problem exhibits *causality* if small changes applied to candidate solutions usually also lead to small changes in their objective values.}

Imagine that we have two candidate solutions&nbsp;$\solspel$ and&nbsp;$\solspel'$ that only differ a little bit.
In our case, these would be two rather similar Gantt charts.
Since they are rather similar, they likely have similar objective values, in our case, makespans.
We can extend this idea to the search space:
Let's say we have two very similar points in the search.
In our case, these would be two permutations with repetitions, that are maybe identical to a large degree and only differ at a few positions.
Likely, these two points would map to similar Gantt charts, which, in turn, would have similar makespans.

This means that if we have one candidate solution, then there probably exist similar solutions with similar makespans.
This means that if we have one *good* candidate solution, then there probably exist similar solutions with similarly *good* makespans.
This means that if we have one *good* candidate solution, then there might even exist similar solutions with *better* makespans.
If we are able to find such a similar but better solution, then the same property *may* hold again:
We can try to find such a better solution and then continue trying to do the same from there and then continue from there.

\definition{rule}{goodCausality}{The neighborhood of a good solution may contain a better solution.}

Local search algorithms&nbsp;[@HS2005SLSFAA; @WGOEB] offer one idea for how to make use of this idea.
They remember one point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$.
In every step, a local search algorithm investigates a point&nbsp;$\sespel'$ derived from and similar to&nbsp;$\sespel$.
From the joined set $\{\sespel,\sespel'\}$, one point is chosen as the (new or old)&nbsp;$\sespel$.
All the other points are discarded.
This step is repeated again and again.


### Ingredient: Unary Search Operation for the JSSP {#sec:jssp:swap2}

The question arises how we can create a candidate solution which is similar to, but also slightly different from, one that we already have?
Our algorithms are working in the search space&nbsp;$\searchSpace$.
So we need one operation which accepts an existing point&nbsp;$\sespel\in\searchSpace$ and produces a slightly modified copy of it as result.
In other words, we need to implement a *unary* search operator!
(We briefly mentioned the concept of unary operators in [@sec:searchOperators], but did not expand on this because the above background is needed to understand the idea.)

On a JSSP with $\jsspMachines$&nbsp;machines and $\jsspJobs$&nbsp;jobs, our representation encodes a schedule as an integer array of length&nbsp;$\jsspMachines*\jsspJobs$ containing each of the job IDs from&nbsp;$0$ to&nbsp;$(\jsspJobs-1)$ exactly $\jsspMachines$&nbsp;times.
The sequence in which these job IDs occur then defines the order in which the jobs are assigned to the machines, which is realized by the decoding function&nbsp;$\decode$ (see [@lst:jssp_encoding]).

One idea to create a slightly modified copy of such a point&nbsp;$\sespel$ in the search space would be to simply swap two of the jobs in it.
Such a&nbsp;`swap2` operator can be implemented as follows:

1. Make a copy&nbsp;$\sespel'$ of the input point&nbsp;$\sespel$ from the search space.
2. Pick a random index&nbsp;$i$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
3. Pick a random index&nbsp;$j$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
4. If the values at indexes&nbsp;$i$ and&nbsp;$j$ in&nbsp;$\sespel'$ are the same, then go back to step&nbsp;3.
5. Swap the values at indexes&nbsp;$i$ and&nbsp;$j$ in&nbsp;$\sespel'$.
6. Return the now modified copy&nbsp;$\sespel'$ of&nbsp;$\sespel$.

Step&nbsp;4 is important since swapping the same values makes no sense, as we would then get&nbsp;$\sespel'=\sespel$.
We would actually not make a "move" and just waste time, because we already have seen and evaluated&nbsp;$\sespel$ before. 

\git.code{mp}{Op1Swap2}{A unary search operator that swaps two elements in a permutation that may contain repeated elements.}{moptipy/operators/permutations/op1_swap2.py}{}{book}{doc,comments}

We implemented this operator in [@lst:Op1Swap2].
Notice that the operator is randomized, i.e., applying it twice to the same point in the search space will likely yield different results.

\rel.figure{jssp_unary_swap2_demo}{An example for the application of `1swap` to an existing point in the search space (top-left) for the `demo` JSSP instance. It yields a slightly modified copy (top-right) with two jobs swapped. If we map these to the solution space (bottom) using the decoding function&nbsp;$\decode$, the changes marked with violet frames occur (bottom-right).}{jssp_unary_swap2_demo.svgz}{width=99.9%}

In [@fig:jssp_unary_swap2_demo], we illustrate the application of this `swap2` operator to one point&nbsp;$\sespel$ in the search space for our&nbsp;`demo` JSSP instance.
It swaps the two jobs at index&nbsp;$i=10$ and&nbsp;$j=15$ of&nbsp;$\sespel$.
In the new, modified copy&nbsp;$\sespel'$, the jobs&nbsp;$3$ and&nbsp;$0$ at these indices have thus traded places.
The impact of this modification becomes visible when we map both&nbsp;$\sespel$ and&nbsp;$\sespel'$ to the solution space using the decoding function&nbsp;$\decode$.
The&nbsp;$3$ which has been moved forward now means that job&nbsp;$3$ will be scheduled before job&nbsp;$1$ on machine&nbsp;$2$.
As a result, the last two operations of job&nbsp;$3$ can now finish earlier on machines&nbsp;$0$ and&nbsp;$1$, respectively.
However, time is wasted on machine&nbsp;$2$, as we need to wait for the first two operations of job&nbsp;$3$ to finish before we can execute it there.
Also, job&nbsp;$1$ finishes now later on that machine, which also delays its last operation to be executed on machine&nbsp;$4$.
This pushes back the last operation of job&nbsp;$0$ (on machine&nbsp;$4$) as well.
The new candidate solution&nbsp;$\decode(\sespel')$ thus has a longer makespan of&nbsp;$\objf(\decode(\sespel'))=195$ compared to the original solution with&nbsp;$\objf(\decode(\sespel))=180$.

In other words, our application of&nbsp;`swap2` in [@fig:jssp_unary_swap2_demo] has led us to a worse solution.
This will happen *most* of the time.
As soon as we have a good solution, the solutions similar to it tend to be worse in average and the number of even better solutions in the neighborhood tends to get smaller.
However, if we would have been at&nbsp;$\sespel'$ instead, an application of `swap2` could well have resulted in&nbsp;$\sespel$.
In summary, we can hope that the chance to find a really good solution by iteratively sampling the neighborhoods of good solutions is higher compared to trying to randomly guessing them (as `rs` does) &nbsp; even if most of our samples are worse.

\definition{rule}{mostSolutionsInNeighborhoodAreBad}{Most of the solutions in the neighborhood of a good solution are worse than that solution. Most of the time, the application of a unary search operator will yield a result worse than its input.}


### Stochastic Hill Climbing Algorithm

#### The Algorithm {#sec:hillClimbing:nors:algorithm}

Stochastic Hill Climbing&nbsp;[@RN2002AI; @S2008TADM; @WGOEB] is the simplest implementation of local search.
It is also sometimes called localized random search&nbsp;[@S2003ITSSAO].
It proceeds as follows:

1. Create one random point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ using the nullary search operator.
2. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the decoding function&nbsp;$\solspel=\decode(\sespel)$.
3. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
4. Repeat until the termination criterion is met:
    a. Apply the unary search operator to&nbsp;$\sespel$ to get a slightly modified copy&nbsp;$\sespel'$ of it.
    b. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the decoding function&nbsp;$\solspel'=\decode(\sespel')$.
    c. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    d. If&nbsp;$\obspel'<\obspel$, then store $\sespel'$&nbsp;in&nbsp;$\sespel$, store $\solspel'$&nbsp;in&nbsp;$\solspel$, and store $\obspel'$&nbsp;in&nbsp;$\obspel$.
6. Return the best encountered objective value&nbsp;$\obspel$ and the best encountered solution&nbsp;$\solspel$ to the user.

This algorithm is implemented in [@lst:HillClimber] and we will refer to it as&nbsp;`hc`.
Notice that `hc` is a very general algorithm, like `rs`.
We can plug arbitrary search and solution spaces, arbitrary decoding functions, arbitrary nullary and unary search operators, and arbitrary termination criteria into it.
We are not limited to the JSSP.

\git.code{mp}{HillClimber}{An excerpt of the implementation of the Hill Climbing algorithm `hc`, which remembers the best-so-far solution and tries to find better solutions in its neighborhood.}{moptipy/algorithms/hill_climber.py}{}{book}{doc,comments}


#### Results on the JSSP {#sec:hc_swap2:jssp:results}

We now plug our unary operator&nbsp;`swap2` into our `hc`&nbsp;algorithm and apply it to the JSSP.
We will refer to this setup as&nbsp;`hc` and present its results with those of&nbsp;`rs` in [@tbl:jssp_hc_results].

\rel.input{end_results_hc.md}

: The results of the hill climber `hc` with the `swap2` operator compared to those of the random sampling algorithm&nbsp;`rs` and to the lower bound&nbsp;$\lowerBound(\objf)$ of the makespan&nbsp;$\objf$: the best and mean result quality and its standard deviation ($\minBestF$, $\meanBestF$, $\stddevBestF$), the mean of the scaled result quality $\meanBestFscaled$, as well as the mean of the milliseconds when the last improvement took place in the runs ($\meanLIFE$, $\meanLIMS$). The summary line at the bottom presents the best, geometric mean, worst, and standard deviation of the scaled result quality over all runs on all instances ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$), as well as $\meanLIFE$ and $\meanLIMS$. See [@sec:statisticalMetrics] for more details. {#tbl:jssp_hc_results}

[@tbl:jssp_hc_results] tells us very clearly that our simple hill climber&nbsp;`hc` performs much better than the random sampling algorithm&nbsp;`rs`. 
It wins in terms of $\minBestF$ and $\meanBestF$ on every single problem instance.
It also has the overall better scaled objective values ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$).
Interestingly, on every single on of our eight benchmark instances, it has a higher standard deviation ($\stddevBestF$) of the end results compared to `rs`.

\rel.figure{makespan_scaled_hc}{Violin plots overlaid with box plots to illustrate the distributions of the (scaled) makespans achieved by `hc` and `rs` on the different JSSP instances.}{makespan_scaled_hc.svgz}{width=99.9%}

\rel.figure{gantt_hc}{The Gantt charts corresponding to the median results of the hill climber&nbsp;`hc`.}{gantt_hc.svgz}{width=99.9%}

The impression on the superior performance of `hc` compared to `rs` is confirmed in [@fig:makespan_scaled_hc], where we plot the scaled end result qualities of our hill climber versus those of random sampling over all JSSP instances.
With the exception of the two smallest-scale instances, the worst result delivered by the hill climber is better than the best result of random sampling.
The median Gantt charts produced by `hc`, illustrated in [@fig:gantt_hc], also appear to be denser with less wasted time than those of `rs` (see [@fig:gantt_rs]).

We also notice from [@tbl:jssp_hc_results] that our `hc`&nbsp;algorithm tends to have a higher per-instance standard deviation of the result qualities ($\stddevBestF$) compared to `rs`.
It also stops improving much earlier:
On `orb06`, its last improvement happens in average after $\meanLIMS=53$&nbsp;milliseconds.
`dmu67` is the instance where it keeps improving the longest, in average, namely for 8.5&nbsp;seconds.
Overall, the `hc`&nbsp;algorithm only makes efficient use of 2.7&nbsp;seconds in mean, i.e., 2.3% of the two minutes of computational budget per run.

In [@fig:progress_hc_log_T; @fig:progress_hc_log_FEs], we compare the progress of our hill climber with `rs` over time, measured in milliseconds and objective function evaluations&nbsp;(FEs), respectively.
We confirm that the hill climber is much better.
After about ten ($=10^1$) milliseconds or 1000 ($=10^3$)&nbsp;FEs, it usually has reached a quality that `rs` can never surpass within the whole computational budget of two minutes.

Unfortunately, the hill climber tends to only find significant improvements during the first second of the runs, i.e., during the first $10^3$&nbsp;milliseconds.

\rel.figure{progress_hc_log_T}{The arithmetic mean of the best-so-far solution quality of `hc` and `rs` over time (with log-scaled time axis).}{progress_hc_log_T.svgz}{width=99.9%}

\rel.figure{progress_hc_log_FEs}{The arithmetic mean of the best-so-far solution quality of `hc` and `rs` over the number of objective function evaluations (FEs, with log-scaled FE axis).}{progress_hc_log_FEs.svgz}{width=99.9%}
