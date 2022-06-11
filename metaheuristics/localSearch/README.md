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

\rel.figure{jssp_unary_swap2_demo}{An example for the application of `swap2` to an existing point in the search space (top-left) for the `demo` JSSP instance. It yields a slightly modified copy (top-right) with two jobs swapped. If we map these to the solution space (bottom) using the decoding function&nbsp;$\decode$, the changes marked with violet frames occur (bottom-right).}{jssp_unary_swap2_demo.svgz}{width=99.9%}

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

Stochastic Hill Climbing&nbsp;[@RN2002AI; @S2008TADM; @JPY1988HEILS; @WGOEB] is the simplest implementation of local search.
It is also sometimes called localized random search&nbsp;[@S2003ITSSAO].
This algorithm starts at a randomly chosen point&nbsp;$\sespel$ in the search space.
In each step, it creates a slightly modified copy&nbsp;$\sespel'$ of&nbsp;$\sespel$.
If $\sespel'$ is better than $\sespel$, it replaces it ($\sespel\leftarrow\sespel'$).
Otherwise, it is discarded.
Spelled out, the hill climber proceeds as follows:

<div id="hill_climber_algo">
1. Create one random point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ using the nullary search operator.
2. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the decoding function&nbsp;$\solspel=\decode(\sespel)$.
3. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
4. Repeat until the termination criterion is met:
    a. Apply the unary search operator to&nbsp;$\sespel$ to get a slightly modified copy&nbsp;$\sespel'$ of it.
    b. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the decoding function&nbsp;$\solspel'=\decode(\sespel')$.
    c. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    d. If&nbsp;$\obspel'<\obspel$, then store $\sespel'$&nbsp;in&nbsp;$\sespel$, store $\solspel'$&nbsp;in&nbsp;$\solspel$, and store $\obspel'$&nbsp;in&nbsp;$\obspel$.
6. Return the best encountered objective value&nbsp;$\obspel$ and the best encountered solution&nbsp;$\solspel$ to the user.
</div>

This algorithm is implemented in [@lst:HillClimber] and we will refer to it as&nbsp;`hc`.
Notice that `hc` is a very general algorithm, like `rs`.
We can plug arbitrary search and solution spaces, arbitrary decoding functions, arbitrary nullary and unary search operators, and arbitrary termination criteria into it.
We are not limited to the JSSP.

\git.code{mp}{HillClimber}{An excerpt of the implementation of the Hill Climbing algorithm `hc`, which remembers the best-so-far solution and tries to find better solutions in its neighborhood.}{moptipy/algorithms/hill_climber.py}{}{book}{doc,comments}


#### Results on the JSSP {#sec:hc_swap2:jssp:results}

We now plug our unary operator&nbsp;`swap2` into our `hc`&nbsp;algorithm and apply it to the JSSP.
We will refer to this setup as&nbsp;`hc` and present its results with those of&nbsp;`rs` in [@tbl:jssp_hc_results].

\rel.input{end_results_hc.md}

: The results of the hill climber `hc` with the `swap2` operator compared to those of the random sampling algorithm&nbsp;`rs` and to the lower bound&nbsp;$\lowerBound(\objf)$ of the makespan&nbsp;$\objf$: the best and mean result quality and its standard deviation ($\minBestF$, $\meanBestF$, $\stddevBestF$), the mean of the scaled result quality $\meanBestFscaled$, as well as the mean of the milliseconds when the last improvement took place in the runs ($\meanLIFE$, $\meanLIMS$). The summary line at the bottom presents the best, geometric mean, worst, and standard deviation of the scaled result quality over all runs on all instances ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$, $\stddevBestFscaled$), as well as $\meanLIFE$ and $\meanLIMS$. See [@sec:statisticalMetrics] for more details. {#tbl:jssp_hc_results}

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


### Stochastic Hill Climbing with Restarts {#sec:stochasticHillClimbingWithRestarts}

Upon close inspection of the results, we notice that we are again in the same situation as with the&nbsp;`1rs` algorithm:
There is some variance between the results and most of the "action" takes place in a short time compared to our total computational budget (1&nbsp;second vs. 2&nbsp;minutes).
Back in [@sec:randomSamplingAlgo] we made use of this situation by simply repeating&nbsp;`1rs` until the computational budget was exhausted, which we called the `rs`&nbsp;algorithm.
Now the situation is a bit different, however.
`1rs`&nbsp;creates exactly one solution and is finished, whereas our hill climber does not actually finish.
It keeps creating modified copies of the current solution, only that these eventually do not mark improvements anymore.
Then, the algorithm has converged into a *local optimum*.

\definition{def}{localOptimum}{A *local optimum* is a point&nbsp;$\localOptimum{\sespel}$ in the search space which maps to a better candidate solution than any other points in its neighborhood (see \def.ref{neighborhood}).}

\definition{def}{prematureConvergence}{An optimization process has prematurely converged if it has not yet discovered the global optimum but can no longer improve its approximation quality.&nbsp;[@WCT2012EOPABT; @WZCN2009WIOD]}

We discuss the phenomenon of premature convergence in detail later in [@sec:prematureConvergence].
Due to the black-box nature of our basic hill climber algorithm, it is not really possible to know when the complete neighborhood of the current solution has been tested.
We thus do not know whether or not the algorithm is trapped in a local optimum and has *prematurely converged*.
However, we can try to guess it:
If there has not been any improvement for a high number&nbsp;$L$ of steps, then the current point&nbsp;$\sespel$ in the search space is probably a local optimum.
If that happens, we just restart at a new random point in the search space.
Of course, we will remember the *best-so-far* candidate solution in a special variable&nbsp;$\bestSoFar{\solspel}$ over all restarts and return it to the user in the end.


#### The Algorithm {#sec:hillClimberWithRestartAlgo}

1. Set counter&nbsp;$C$ of unsuccessful search steps to&nbsp;$0$.
2. Set the best-so-far objective value&nbsp;$\bestSoFar{\obspel}$&nbsp;to&nbsp;$+\infty$ and the best-so-far candidate solution&nbsp;$\bestSoFar{\solspel}$ to&nbsp;`None`. 
3. Create a random point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ using the nullary search operator.
4. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the decoding function&nbsp;$\solspel=\decode(\sespel)$.
5. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
6. If&nbsp;$\obspel<\bestSoFar{\obspel}$, then store&nbsp;$\obspel$&nbsp;in&nbsp;$\bestSoFar{\obspel}$ and store&nbsp;$\solspel$&nbsp;in&nbsp;$\bestSoFar{\solspel}$.
7. Repeat until the termination criterion is met:
    a. Apply the unary search operator to&nbsp;$\sespel$ to get the slightly modified copy&nbsp;$\sespel'$ of it.
    b. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the decoding function&nbsp;$\solspel'=\decode(\sespel')$.
    c. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    d. If&nbsp;$\obspel'<\obspel$, then
        i. store&nbsp;$\obspel'$&nbsp;in&nbsp;$\obspel$ and store&nbsp;$\sespel'$&nbsp;in&nbsp;$\sespel$ and
        ii. set&nbsp;$C$ to&nbsp;$0$.
        iii. If&nbsp;$\obspel'<\bestSoFar{\obspel}$, then store&nbsp;$\obspel'$&nbsp;in&nbsp;$\bestSoFar{\obspel}$ and store&nbsp;$\solspel'$&nbsp;in&nbsp;$\bestSoFar{\solspel}$.
        
       otherwise, i.e., if&nbsp;$\obspel'\geq \obspel$, then
      
        iv. increment&nbsp;$C$ by&nbsp;$1$.
        v. If&nbsp;$C\geq L$, then perform a restart by going back to *step&nbsp;3*.
8. Return best encountered objective value&nbsp;$\bestSoFar{\obspel}$ and the best encountered solution&nbsp;$\bestSoFar{\solspel}$ to the user.

\git.code{mp}{HillClimberWithRestarts}{An excerpt of the implementation of the Hill Climbing algorithm with restarts, which remembers the best-so-far solution and tries to find better solutions in its neighborhood but restarts if it seems to be trapped in a local optimum.}{moptipy/algorithms/hill_climber_with_restarts.py}{}{book}{doc,comments}

Now this algorithm &ndash; implemented in [@lst:HillClimberWithRestarts] &ndash; is a bit more elaborate.
Basically, we embed the original hill climber into a loop.
This inner hill climber will stop after a certain number&nbsp;$L$ of unsuccessful search steps, which then leads to a new round in the outer loop.
In combination with the `swap2`&nbsp;operator, we refer to this algorithm as `hcr_L_swap2`, where `L`&nbsp;is to be replaced with the actual value of the parameter&nbsp;$L$.


#### The Right Setup {#sec:hillClimberWithRestartSetup}

This is the first time that we have an algorithm with a (numerical) parameter.
Obviously, the performance of our `hcr_L_swap2` algorithm will depend strongly on the value of&nbsp;$L$.
Unfortunately, we now realize that we actually have no idea which value of&nbsp;$L$ is good.
If we pick it too low, then the algorithm will restart before it actually converges to a local optimum, i.e., stop while it could still improve.
If we pick it too high, we waste runtime and do fewer restarts than what we could do.

If we do not know which value for a parameter is reasonable, we can always do an experiment to investigate.
We simply apply our algorithm for different values of&nbsp;$L$ to all the eight benchmark instances, 23&nbsp;times each.
Since the order of magnitude of the proper value for&nbsp;$L$ is not yet clear, it makes sense to test exponentially increasing numbers.
Here, we test the powers of two from $2^7=128$ to $2^{20}=1'048'576$.
For each value, we plot the geometric mean of the scaled end result quality over the $23*8=184$&nbsp;runs that we get for each setup in total.
In this diagram, the horizontal axis is logarithmically scaled.

From the plot, we can confirm our expectations:
Small numbers of&nbsp;$L$ perform bad and high numbers of&nbsp;$L$ cannot really improve above the basic hill climber.
Actually, if we would set&nbsp;$L$ to a number larger than the overall budget, then we would obtain exactly the original hill climber, as it would never perform any restart.

\rel.figure{hcr_L_swap2_results}{The geometric mean of the best-so-far solution quality of `hcr_L_swap2` at the end of the runs, plotted over different values of the parameter $L$ (with log-scaled horizontal axis).}{hcr_L_swap2_results.svgz}{width=90%}

In [@fig:hcr_L_swap2_results], we present the geometric means of the end result qualities of `hcr_L_swap2` for our eight JSSP instances for the different values of&nbsp;$L$.
We also show the geometric means over all instances together.
A value of&nbsp;$L$ is the better, the smaller these mean makespans are. 
For instances with small search space like `orb06`, small values of&nbsp;$L$ like $2^{11}=2048$ are good.
For instances with large search spaces like `ta70` or `dmu67`, larger values such as $2^{16}=65'536$ work well.
If we look at the overall geometric mean, i.e., the thick red line, $L=2^{15}=32'768$ comes out as best setting.
We will therefore choose this setup and refer to it as `hcr` for the sake of simplicity.  


#### Results on the JSSP {#sec:hcr_L_swap2:jssp:results}

Let us now compare the performance this setup, `hcr_32768_swap2` (or `hcr` for brevity), with `hc` and&nbsp;`rs`. 
From [@tbl:end_results_hcr], we find that `hcr` is better than the other two algorithms on every instance.
If has the best $\minBestF$, $\meanBestF$, $\stddevBestF$, and $\meanBestFscaled$ on every instance.
It also has the best overall $\minBestFscaled$, $\geomeanBestFscaled$, and $\maxBestFscaled$.

The standard deviation $\stddevBestF$ of the end result qualities of `hcr` is smaller than the one of the other two algorithms.
This means that we effectively utilized the variance in the results of `hc` to obtain better results (see \def.ref{exploitVariance}).
The time until the algorithm stops improving ($\meanLIFE$, $\meanLIMS$) of `hcr` is also significantly higher than of `hc`.
It often keeps improving for ten times as many FEs or milliseconds.
This means that we now utilize our computational budget much better. 

[@fig:makespan_scaled_hcr] shows again the box plots on top of the violin plots of the end results makespans.
Here, the results of `hcr` look a bit as if we had taken the output of `hc` and squashed it all together at the bottom (best) values.
This is essentially what `hcr` is doing, it is essentially a restarted version of `hc`.
But unlike `rs`, which is a restarted version of `1rs`, we cannot perform tens of thousands of restarts.

If we take a look at the progress plots in [@fig:progress_hcr_log_T], we find that the runs of `hcr` initially closely follow those of `hc`.
Indeed, `hcr` is exactly `hc` until it restarts.
After the restart takes place, some time needs to pass until one restart exceeds the best solution quality, and then the curves of `hcr` and `hc` will split.
These splits happen at between $4*10^2 ms = 0.4 s$ (`orb06`, `la38`) and $2*10^3 ms = 2 s$ (e.g., `dmu67`, `swv14`).
Given a total runtime of two minutes, this means that the algorithm will probably not restart more than 100 to 500 times.
The performance plots also fit well to our the findings from [@fig:hcr_L_swap2_results]:
The smaller-scale instances like `orb06` would benefit from earlier restarts (smaller&nbsp;$L$), as they temporarily hit a plateau before improving again.
Earlier restarts, however, would probably cut off the last few improvements on the larger-scale instances, which do not hit such plateaus.
(By the way, the progress plots are log-scaled, meaning that a plateau of 0.2&nbsp;seconds length will look much smaller on the right side of the figure of `orb06`, which is why you only see it prominently once although it occurs multiple times.)

Either way:
While the improvements get smaller and smaller and occur slower and slower towards the end of the computational budget, we still get improvements during all the runtime.

Also, the Gantt charts of the median result of `hcr` illustrated in [@fig:gantt_hcr] are again more compact than those for `hc` ([@fig:gantt_hcr]).
Matter of fact, on `orb06` the median solution is now very close to the optimal result and also on `la38`, we are not that far away from it.
While `hcr` is still a very simple method, our results now look somewhat reasonable. 

\rel.input{end_results_hcr.md}

: The results of the hill climber with restarts `hcr` with $L=32'768$ and the `swap2` operator compared to those of the basic hill climber&nbsp;`hc`, random sampling algorithm&nbsp;`rs` and  to the lower bound&nbsp;$\lowerBound(\objf)$ of the makespan&nbsp;$\objf$: the best and mean result quality and its standard deviation ($\minBestF$, $\meanBestF$, $\stddevBestF$), the mean of the scaled result quality $\meanBestFscaled$, as well as the mean of the milliseconds when the last improvement took place in the runs ($\meanLIFE$, $\meanLIMS$). The summary line at the bottom presents the best, geometric mean, worst, and standard deviation of the scaled result quality over all runs on all instances ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$, $\stddevBestFscaled$), as well as $\meanLIFE$ and $\meanLIMS$. See [@sec:statisticalMetrics] for more details. {#tbl:end_results_hcr}

\rel.figure{makespan_scaled_hcr}{Violin plots overlaid with box plots to illustrate the distributions of the (scaled) makespans achieved by `hcr`, `hc`, and `rs` on the different JSSP instances.}{makespan_scaled_hcr.svgz}{width=99.9%}

\rel.figure{progress_hcr_log_T}{The arithmetic mean of the best-so-far solution quality of `hcr`, `hc`, and `rs` over time (with log-scaled time axis).}{progress_hcr_log_T.svgz}{width=99.9%}

\rel.figure{gantt_hcr}{The Gantt charts corresponding to the median results of the hill climber&nbsp;`hcr` with restarts after $L=32'768$ unsuccessful moves.}{gantt_hcr.svgz}{width=99.9%}


#### Drawbacks of the Idea of Restarts

With our restart method, we could significantly improve the results of the hill climber.
It did not directly address the problem of premature convergence to a local optimum.
However, it tried to find a remedy for its symptoms, not for its cause. 

Basically, a restarted algorithm is still the same algorithm &ndash; we just restart it again and again.
If there are many more local optima than global optima, every restart will probably end again in a local optimum.
If there are many more ``bad'' local optima than ``good'' local optima, every restart will probably end in a ``bad'' local optimum.
While restarts improve the chance to find better solutions, they cannot solve the intrinsic shortcomings of an algorithm.

Another problem is:
With every restart we throw away all accumulated knowledge and information of the current run.
Restarts are therefore also wasteful.


### Hill Climbing with a Different Unary Operator {#sec:hillClimbingWithDifferentUnaryOperator}

#### Small vs. Large Neighborhoods &ndash; and Uniform vs. Non-Uniform Sampling 

One of issues limiting the performance of our restarted hill climber could be the design of the unary operator.
`swap2`&nbsp;will swap two jobs in an encoded solution.
Since the solutions are encoded as integer arrays of length&nbsp;$\jsspMachines*\jsspJobs$, there are&nbsp;$\jsspMachines*\jsspJobs$ possible choices when picking the index of the first job to be swapped.
We swap only with *different* jobs and each job appears&nbsp;$\jsspMachines$ times in the encoding.
This leaves&nbsp;$\jsspMachines*(\jsspJobs-1)$ choices for the second swap index, because we will only use a second index that points to a different job ID.
If we think about the size of the neighborhood spanned by `swap2`, we can also ignore equivalent swaps:
Exchanging the jobs at indexes $(10,5)$ and $(5,10)$, for example, would result in the same outcome.
In total, from any given point in the search space, `swap2` may reach&nbsp;$0.5*(\jsspMachines*\jsspJobs)*[\jsspMachines*(\jsspJobs-1)]=0.5*\jsspMachines^2(\jsspJobs^2-\jsspJobs)$ different other points.
Some of these points might still actually encode the same candidate solutions, i.e., identical schedules.
In other words, the neighborhood spanned by our `swap2`&nbsp;operator equals only a tiny fraction of the huge search space (remember [@tbl:jsspSearchSpaceTable]).

This has two implications:
      
1. The chance of premature convergence for a hill climber applying this operator is relatively high, since the neighborhoods are relatively small.
   If the neighborhood spanned by the operator was larger, it would contain more, potentially better solutions.
   Hence, it would take longer for the optimization process to reach a point where no improving move can be discovered anymore.
2. Assume that there is no better solution in the `swap2` neighborhood of the current best point in the search space.
   There might still be a much better, similar solution.
   Finding it could, for instance, require swapping three or four jobs &ndash; but the `hc_swap2` algorithm will never find it, because it can only swap two jobs.
   If the search operator would permit such moves, then even the plain hill climber may discover this better solution.

If we look at it like this, we realize that maybe our unary search operator does indeed limit the performance of our algorithm.
So let us try to think about how we could define a new unary operator which can access a larger neighborhood.
As we should always do, we first consider the extreme cases.

On the one hand, we have `swap2` which samples from a relatively small neighborhood.
Because the neighborhood is small, the stochastic hill climber will eventually have visited all of the solutions it contains.
If none of them is better than the current best solution, it will not be able to depart from it.

The other extreme could be an operator that can access the complete search space&nbsp;$\searchSpace$ from any point in it.
Imagine that we build such an operator to *uniformly* sample from&nbsp;$\searchSpace$.
Actually, we already have this operator:
It is our nullary operator from [@lst:Op0Shuffle]!
What would happen if we used this nullary operator as unary operator?
It would return an entirely random point from the search space&nbsp;$\searchSpace$ and ignore its input.
Then, each point&nbsp;$\sespel\in\searchSpace$ would have the whole&nbsp;$\searchSpace$ as the neighborhood.
This would turn the hill climber into random sampling.
Stop. Halt. No.
We do not want that.

From this thought experiment we know that unary operators which indiscriminately sample from very large neighborhoods are probably not very good ideas, as they are "too random."
They also make less use of the causality of the search space, as they make large steps and their produced outputs are very different from their inputs.

Using an operator that creates larger neighborhoods than `swap2`, which are still smaller than&nbsp;$\searchSpace$ would be one idea.
For example, we could always swap three jobs instead of two.
The more jobs we swap in each application, the larger the neighborhood gets.
Then we will be less likely to get trapped in local optima.
Actually, there would be fewer local optima, because local optima are defined from the perspective of the neighborhood, which, in turn, is defined by the search operator.
However, if we do more swaps, we will also make less and less use of the causality property, i.e., the solutions we derive from the current best one will be more and more different from it.
Where should we draw the line?
How many jobs should we swap?

Hm.
There is one more aspect of the operators that we did not think about yet.
An operator does not just span a neighborhood, but it also defines a *probability distribution* over it.
So far, our `swap2` unary operator samples *uniformly* from the neighborhood of its input.
In other words, all of the $0.5*\jsspMachines^2(\jsspJobs^2-\jsspJobs)$ new points that it could create in one step have exactly the same probability, the same chance to be chosen.

But we do not need to do it like that.
We could construct an operator that *often* creates outputs very similar to its input (like `swap2`), but also, *sometimes*, samples points a bit farther away in the search space.
This operator could have a huge neighborhood &ndash; but sample it *non-uniformly*.


#### Second Unary Search Operator for the JSSP {#sec:jsspUnaryOperator2}

We define the `swapn`&nbsp;operator for the JSSP as follows and implement it in [@lst:Op1SwapN]:

\git.code{mp}{Op1SwapN}{A unary search operator that swaps a random number of elements (often few, sometimes many) in a permutation that may contain repeated elements.}{moptipy/operators/permutations/op1_swapn.py}{}{book}{doc,comments}

1. Make a copy&nbsp;$\sespel'$ of the input point&nbsp;$\sespel$ from the search space.
2. Pick a random index&nbsp;$i$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
3. Store the job-id at index&nbsp;$i$ in the variable&nbsp;$\mathit{first}$ for holding the very first job, i.e., set&nbsp;$f=\arrayIndex{\sespel'}{i}$.
4. Set the job-id variable&nbsp;$\mathit{last}$ for holding the last-swapped-job to&nbsp;$\arrayIndex{\sespel'}{i}$ as well.
5. Set $\mathit{continueAfter}$, the variable deciding whether to do another swap after the current one, to `True`.
6. While $\mathit{continueAfter}$ is `True`:
    a. Decide whether we should continue the loop *after* the current iteration (`True`) or not (`False`) with equal probability and remember this decision in variable&nbsp;$\mathit{continueAfter}$.
    b. Pick a random index&nbsp;$j$ from $0\dots(\jsspMachines*\jsspJobs-1)$.
    c. If $\mathit{last}=\arrayIndex{\sespel'}{j}$, go back to point&nbsp;b.
    d. If $\mathit{continueAfter}$ is `False` and $\mathit{first}=\arrayIndex{\sespel}{j}$, go back to point&nbsp;b.
    e. Store the job-id at index&nbsp;$j$ in the variable&nbsp;$\mathit{last}$.
    f. Copy the job-id at index&nbsp;$j$ to index&nbsp;$i$, i.e., set&nbsp;$\arrayIndex{\sespel'}{i}=\arrayIndex{\sespel'}{j}$.
    g. Set&nbsp;$i=j$.
7. Store the first-swapped job-id&nbsp;$\mathit{first}$ in&nbsp;$\arrayIndex{\sespel'}{i}$.
8. Return the now modified copy&nbsp;$\sespel'$ of&nbsp;$\sespel$.
    
Here, the idea is that we will perform at least one iteration of the loop (*point&nbsp;6*).
If we would do exactly one iteration, then we would need to pick two indices&nbsp;$i1$ and&nbsp;$i2$ where different job-IDs are stored, as&nbsp;$last$ must be different from&nbsp;$first$ (*point&nbsp;c* and&nbsp;*d*).
We would then swap the jobs at these indices (*points&nbsp;f*, *g*, and&nbsp;*7*).
In the case of exactly one iteration of the main loop, this operator behaves the same as&nbsp;`swap2`.
This takes place with a probability of&nbsp;0.5 (*point&nbsp;a*).

If we do two iterations, i.e., pick `True` the first time we arrive at *point&nbsp;a* and `False` the second time, then we swap three job-IDs instead.
Let us say we picked indices&nbsp;$\alpha$ at *point&nbsp;2*, $\beta$ at *point&nbsp;b*, and&nbsp;$\gamma$ when arriving the second time at&nbsp;*b*.
We will store the job-ID originally located at index&nbsp;$\beta$ at index&nbsp;$\alpha$, the job originally stored at index&nbsp;$\gamma$ at index&nbsp;$\beta$, and the job-ID from index&nbsp;$\gamma$ to index&nbsp;$\alpha$.
*Condition&nbsp;c* prevents index&nbsp;$\beta$ from referencing the same job-ID as index&nbsp;$\alpha$ and index&nbsp;$\gamma$ from referencing the same job-id as what was originally stored at index&nbsp;$\beta$.
*Condition&nbsp;d* only applies in the last iteration and prevents&nbsp;$\gamma$ from referencing the original job-ID at&nbsp;$\alpha$.

This three-job swap will take place with probability&nbsp;$0.5*0.5=0.25$.
Similarly, a four-job-swap will happen with half of that probability, and so on.
In other words, we have something like a Bernoulli process, where we decide whether or not to do another iteration by flipping a fair coin, where each choice has probability&nbsp;0.5.
The number of iterations will therefore be geometrically distributed with an expectation of two job swaps.
Of course, we only have&nbsp;$\jsspMachines$ different job-IDs in a finite-length array&nbsp;$\sespel'$, so this is only an approximation.
Sometimes, a longer sequence of swaps may undo early swaps later on, too.
In summary, this operator will most often apply small changes and sometimes bigger steps.
The bigger the search step, the less likely will it be produced.
The operator therefore can make use of the *causality* while &ndash; at least theoretically &ndash; being able to escape from any local optimum.


#### Results on the JSSP

Let us now compare the end results that our hill climbers can achieve using either the `swap2` or the new `swapn`&nbsp;operator after two minutes of runtime on my computer in [@tbl:end_results_hcn].
We find immediately that `hcn` is better than `hc`, i.e., that the hill climber with the new `swapn` operator can consistently deliver better solutions than hill climber using `swap2`.
It wins in each instance in terms of $\minBestF$ and $\meanBestF$ as well as in the overall $\minBestFscaled$, $\geomeanBestFscaled$, and $\maxBestFscaled$ against `hc`.
Surprisingly, on `orb06`, `abz8`, `dmu72`, and `dmu67`, the best result discovered by any run ($\minBestF$) is even better compared to the hill climber with restarts and `swap2`, i.e., `hcr`.
However, in average, `hcr` is still better than `hcn`.

The `swapn` operator clearly does what it is supposed to do:
It allows the hill climber to escape from local optima and thus allows it to improve for a longer time.
Therefore, the values of $\meanLIFE$ and $\meanLIMS$ are higher for `hcn` than for `hc`, although not as high as for `hcr`.

\rel.input{end_results_hcn.md}

: The results of the hill climbers with the `swapn` and the `swap2` operator as well as the hill climber with restarts `hcr` compared to the lower bound&nbsp;$\lowerBound(\objf)$ of the makespan&nbsp;$\objf$: the best and mean result quality and its standard deviation ($\minBestF$, $\meanBestF$, $\stddevBestF$), the mean of the scaled result quality $\meanBestFscaled$, as well as the mean of the milliseconds when the last improvement took place in the runs ($\meanLIFE$, $\meanLIMS$). The summary line at the bottom presents the best, geometric mean, worst, and standard deviation of the scaled result quality over all runs on all instances ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$, $\stddevBestFscaled$), as well as $\meanLIFE$ and $\meanLIMS$. See [@sec:statisticalMetrics] for more details. {#tbl:end_results_hcn}

From [@fig:makespan_scaled_hcn], we find that the results of `hcn` are spread wider than those of the hill climber with restarts (`hcr`).
They are also visibly better than those of the hill climber with `swap2` (`hc`), with one exception:
On the problem instance `dmu67`, they are just spread over a wider range, but this wider range is not lower (better) but more or less parallel to the result-cloud of `hc`.
Here, a statistical test (see [@sec:testForSignificance] would probably not find a significant difference between `hc` and `hcn`. 

\rel.figure{makespan_scaled_hcn}{Violin plots overlaid with box plots to illustrate the distributions of the (scaled) makespans achieved by `hcn`, `hcr`, and `hc` on the different JSSP instances.}{makespan_scaled_hcn.svgz}{width=99.9%}

In [@fig:progress_hcn_log_T], we illustrate the best-so-far solution quality over the runtime in milliseconds (log-scaled).
We find that `hcn` is slower than both `hc` and&nbsp;`hcr` but keeps improving longer than&nbsp;`hc`.

Why is it initially slower?
There could be two possible explanations:
First, maybe `swapn` yields, in average, worse solutions compared to `swap2` (but can escape local optima).
In \def.ref{causality} and \def.ref{goodCausality}, we learned that similar solutions often have similar qualities.
In \def.ref{mostSolutionsInNeighborhoodAreBad}, we learned that most solutions in the neighborhood of a good solution are worse than that solution.
Of course, the bigger the neighborhood, the more worse solution it contains and the longer it will take to find the better ones.
So this could be one reason for&nbsp;`hc2` being slower compared to&nbsp;`hc`.

Second, maybe `swapn` is just slower, i.e., applying `swapn` once takes longer than applying `swap2` once.
We can test both hypothesis by also plotting the best-so-far solution quality over the runtime in terms of objective function evaluations (FEs) in [@fig:progress_hcn_log_FEs].
If the first hypothesis is true, then these charts would look more or less like those plotted over clock time in [@fig:progress_hcn_log_T].
But they look actually different:
In [@fig:progress_hcn_log_FEs], `hcn` is even initially faster on some instances than `hc`.
Most of the time, the performance curves of `hcn` and `hc` plotted over FEs look more or less the same.
`hc2` keeps improving longer, though.
Also its curves end *earlier*, meaning that it can finish fewer FEs within the same budget of two minutes compared to&nbsp;`hc`.  

\rel.figure{progress_hcn_log_T}{The arithmetic mean of the best-so-far solution quality of `hcn`, `hc`, and `hcr` over time (with log-scaled time axis).}{progress_hcn_log_T.svgz}{width=99.9%}

\rel.figure{progress_hcn_log_FEs}{The arithmetic mean of the best-so-far solution quality of `hcn`, `hc`, and `hcr` over the consumed FEs (with log-scaled time axis).}{progress_hcn_log_FEs.svgz}{width=99.9%}

The hill climber `hc` with the `swap2` operator eventually stops improving because it arrived in a local optimum.
The local optimum is surrounded by better or equally-good solutions.
With the operator `swap2`, `hc` will not be able to escape.
`hcn`, however, uses `swapn` which can potentially reach any other point in the search space, only the probability to do decreases with number of jobs that need to be swapped.
It can therefore keep improving until the end of the budget.

However, we found that the operator `swapn` takes more clock time to apply compared to `swap2`.
Unfortunately, this shortens the period towards the end where its advantages, its ability to escape local optima, kick in.



### Combining Bigger Neighborhood with Restarts

By now, we have discovered two ways to improve upon the simple hill climber `hc` with the `swap2` operator:

1. We can restart the algorithm to exploit the variance.
2. We can replace the unary search operator with another one.

Both restarts and the idea of allowing bigger search steps with small probability are intended to decrease the chance of premature convergence.
We have seen that both measures work separately.
The fact that `hc`+ `swapn` improves more and more slowly towards the end of the computational budget means that it could be interesting to try to combine both ideas, restarts and larger neighborhoods.

We plug the `swapn` operator into the hill climber with restarts and obtain algorithm `hcr_L_swapn`.
We perform the same experiment to find the right setting for the restart limit&nbsp;$L$ as for the `hcr_L_swap2` algorithm and illustrate the results in [@fig:hcr_L_swapn_results].

\rel.figure{hcr_L_swapn_results}{The geometric mean of the best-so-far solution quality of `hcr_L_swapn` at the end of the runs, plotted over different values of the parameter $L$ (with log-scaled horizontal axis).}{hcr_L_swapn_results.svgz}{width=90%}

The "sweet spot" for the number of unsuccessful FEs before a restart has increased compared to before.
This makes sense, because we already know that `swapn` can keep improving longer.
Overall, it seems that `hcr_65536_swapn` performs best.
We will refer to this setup as `hcrn` in the following text.


#### Results on the JSSP

From the end results statistics in [@tbl:end_results_hcrn], we find that combining the idea of restarts with the larger neighborhood worked out, although not as well as we hoped for.
The new setup `hcrn` performs best on the small-scale problem instances `orb06` and `la38`.
It also outperforms its non-restarted variant `hcn` most of the time.
But it loses against `hcr` on `ta70` and `swv14`.

\rel.input{end_results_hcrn.md}

: The results of the hill climbers with restarts and the `swapn` and the `swap2` operator, `hcrn` and `hcr`, respectively, as well as the results of `hcn`, compared with the $\lowerBound(\objf)$ of the makespan&nbsp;$\objf$: the best and mean result quality and its standard deviation ($\minBestF$, $\meanBestF$, $\stddevBestF$), the mean of the scaled result quality $\meanBestFscaled$, as well as the mean of the milliseconds when the last improvement took place in the runs ($\meanLIFE$, $\meanLIMS$). The summary line at the bottom presents the best, geometric mean, worst, and standard deviation of the scaled result quality over all runs on all instances ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$, $\stddevBestFscaled$), as well as $\meanLIFE$ and $\meanLIMS$. See [@sec:statisticalMetrics] for more details. {#tbl:end_results_hcrn}

The distribution of the makespans illustrated in [@fig:makespan_scaled_hcrn] confirm that `hcrn` can clearly harness the variance of the end result quality from `hcn`:
The results of `hcrn` are spread much thinner than those of `hcn`.
However, compared to `hcr`, there is no real tangible difference.

This also becomes visible in the performance plots of [@fig:progress_hcrn_log_T].
Here, all three algorithms, `hcrn`, `hcn`, and `hcr`, have rather similar runtime-quality curves.
The hill climber `hcn` using `swapn` is not as good as the other two methods.
But there is no striking reason to prefer any of the two unary search operators as long as restarts are used, i.e., `hcrn` and `hcr` perform more or less the same.
(Remember here that very small differences in the table and diagrams could as well be caused by the randomness in the experiments.)

\rel.figure{makespan_scaled_hcrn}{Violin plots overlaid with box plots to illustrate the distributions of the (scaled) makespans achieved by `hcrn`, `hcr`, and `hcn` on the different JSSP instances.}{makespan_scaled_hcrn.svgz}{width=99.9%}

\rel.figure{progress_hcrn_log_T}{The arithmetic mean of the best-so-far solution quality of `hcrn`, `hcn`, and `hcr` over time (with log-scaled time axis).}{progress_hcrn_log_T.svgz}{width=99.9%}


### Randomized Local Search (RLS)

When defining the hill climbing algorithms in [@sec:hillClimbing:nors:algorithm], we made one interesting implementation choice.
In each step, we create a modified copy&nbsp;$\sespel'$ of the current-best solution&nbsp;$\sespel$.
If $\sespel'$ is *better* than&nbsp;$\sespel$, we accept it as the new&nbsp;$\sespel$.
Otherwise, it is discarded.
What if it is not better, but *equally good*?
Well, we will discard it, too.

This might actually not be a very wise decision.
Solutions of the JSSP are Gantt charts.
The quality (objective value) of a Gantt chart is its makespan, i.e., the time when the last job finishes.
Let us look again at some Gantt charts, e.g., those in [@fig:gantt_hc] obtained by the simple hill climber.
We find that some machines finish their work early, but only the last job on the last machine determines the makespan.
We could change the order of some of the jobs on the other machines, making them maybe a bit faster or slower.
But as long as they finish before the very last machine, the new Gantt chart would still have the same makespan.
This means that there probably exist many Gantt charts which differ in the arrangement of jobs on some machines but that are similar in the job sequence on the "makespan-determining" machine and that have the same makespan.
Furthermore, as we know from [@sec:size_of_jssp_search_space], the search space&nbsp;$\searchSpace$ that we chose is much larger than the solution space&nbsp;$\solutionSpace$ and many of the permutations in&nbsp;$\searchSpace$ will map to exactly the same Gantt chart.
In summary:
We know that there will be many similar points&nbsp;$\sespel_1,\sespel_2$ in the search space&nbsp;$\searchSpace$ with the same objective value&nbsp;$\objf(\sespel_1)=\objf(\sespel_2)$.
But the hill climber would *never* move from&nbsp;$\sespel_1$ to&nbsp;$\sespel_2$.
(Regardless of whether we use the `swap2` or `swapn` operator.)

Much later in this book we will discuss features that make optimization problems hard.
We will discuss that neighboring solutions with the same objective values can form so-called "neutral networks" (\def.ref{neutralNetwork} in [@sec:neutrality:problem]) along which an optimization process can "drift".
Indeed, we could imagine that our simple hill climber, even with the `swap2` operator, could potentially escape from local optima if we would allow it to also accept solutions of the same quality as the current best solution.
The algorithm is specified below and implemented in [@lst:RLS]. 

\git.code{mp}{RLS}{An excerpt of the implementation of the random local search (RLS) algorithm, which remembers the best-so-far solution and tries to move to solutions in its neighborhood that are not worse.}{moptipy/algorithms/rls.py}{}{book}{doc,comments}

1. Create one random point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$ using the nullary search operator.
2. Map the point&nbsp;$\sespel$ to a candidate solution&nbsp;$\solspel$ by applying the decoding function&nbsp;$\solspel=\decode(\sespel)$.
3. Compute the objective value by invoking the objective function&nbsp;$\obspel=\objf(\solspel)$.
4. Repeat until the termination criterion is met:
    a. Apply the unary search operator to&nbsp;$\sespel$ to get a slightly modified copy&nbsp;$\sespel'$ of it.
    b. Map the point&nbsp;$\sespel'$ to a candidate solution&nbsp;$\solspel'$ by applying the decoding function&nbsp;$\solspel'=\decode(\sespel')$.
    c. Compute the objective value&nbsp;$\obspel'$ by invoking the objective function&nbsp;$\obspel'=\objf(\solspel')$.
    d. If&nbsp;**$\obspel'\leq\obspel$**, then store $\sespel'$&nbsp;in&nbsp;$\sespel$, store $\solspel'$&nbsp;in&nbsp;$\solspel$, and store $\obspel'$&nbsp;in&nbsp;$\obspel$.
6. Return the best encountered objective value&nbsp;$\obspel$ and the best encountered solution&nbsp;$\solspel$ to the user.

This version of the algorithm is called *randomized local search* (RLS)&nbsp;[@NW2007RLSEAATMSTP].
Sometimes it is also called (1+1)-EA, depending on the unary search operator that is applied&nbsp;[@NW2007RLSEAATMSTP].
But since we will discuss evolutionary algorithms later, we will stick to RLS for now.
There is only one difference between the definition of RLS and the [basic hill climber algorithm](#hill_climber_algo) from [@sec:hillClimbing:nors:algorithm]:
In *line&nbsp;4.d*, it accepts the new solution if $\obspel'\leq\obspel$ instead of $\obspel'<\obspel$.
In other words, in RLS the new solution is accepted if it is *not worse* than the current best one, whereas in `hc`, it is accepted only if it is *better*.
RLS therefore can drift along neutral pathways in the search space if they exist.
If they do not exit, RLS and the hill climber will essentially perform the same.
So let us investigate what we can get on the JSSP.


#### Results on the JSSP {#sec:rls_results_on_jssp}

We will test two random local search algorithm setups:
We call random local search with the `swap2` operator `rls` and will denote random local search with `swapn` as `rlsn`.
In the end-of-run statistics listed in [@tbl:end_results_rls], we can immediately see that both RLS algorithms outperform both hill climbers with restarts by a large margin.
They win in the best results they find over all runs ($\minBestF$) and in the average end result quality ($\meanBestF$) on every single instance.
The geometric mean of the scaled end result qualities over all instances of `rls` is 1.072, whereas `hcr` achieves only 1.223, i.e., is 14% worse.
Overall, `rls` outperforms `rlsn`, except on the two smallest instances `orb06` and `la38`.

\rel.input{end_results_rlsn.md}

: The results of the randomized local search versus the hill climbers with restarts for both the `swapn` and the `swap2` operator, compared with the $\lowerBound(\objf)$ of the makespan&nbsp;$\objf$: the best and mean result quality and its standard deviation ($\minBestF$, $\meanBestF$, $\stddevBestF$), the mean of the scaled result quality $\meanBestFscaled$, as well as the mean of the milliseconds when the last improvement took place in the runs ($\meanLIFE$, $\meanLIMS$). The summary line at the bottom presents the best, geometric mean, worst, and standard deviation of the scaled result quality over all runs on all instances ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$, $\stddevBestFscaled$), as well as $\meanLIFE$ and $\meanLIMS$. See [@sec:statisticalMetrics] for more details. {#tbl:end_results_rls}

The distributions of the end result qualities are sketched in [@fig:makespan_scaled_rlsn].
For the larger six of our eight benchmark instances, the distributions of RLS are so much better that they do not even overlap with those of the restarted hill climbers.
On the smaller two problems, they are still visibly better.
`rls` tends to have better median results than `rlsn`.

From [@tbl:end_results_rls], we know that, in average, the last improvement during a run happens for `rls` after 4.4&nbsp;million FEs and for `hcr` after 3.8&nbsp;million FEs.
In other words, the RLS algorithms improve for a longer time than the hill climbers, even if we restart the hill climbers.
This is also very visible in the progress charts of [@fig:progress_rlsn_log_T].
On several of our JSSP instances, the RLS algorithms keep improving until the very end of the computational budget.

\rel.figure{makespan_scaled_rlsn}{Violin plots overlaid with box plots to illustrate the distributions of the (scaled) makespans achieved by `rls`, `rlsn`, `hcr`, and `hcrn` on the different JSSP instances.}{makespan_scaled_rlsn.svgz}{width=99.9%}

\rel.figure{progress_rlsn_log_T}{The arithmetic mean of the best-so-far solution quality of `rls`, `rlsn`, `hcr`, and `hcrn` over time (with log-scaled time axis).}{progress_rlsn_log_T.svgz}{width=99.9%}

Since we found that our RLS algorithms perform so much better than the hill climbers, it is also time to draw some Gantt charts.
In [@fig:gantt_rls], we plot the Gantt charts corresponding to the median result of `rls` (RLS with `swap2`) for each instance.
The operations are now packed much tighter.
The makespan of the schedules is closer to quality $\lowerBound$ of the known optimal solution.
Especially on the large (but nevertheless easy) instance `ta70`, the median schedule with 3020&nbsp;time units length only slightly exceeds the lower bound of 2995&nbsp;time units.
Indeed, `rls` even discovered on solution that is optimal during four of its runs.
For your enjoyment, we plot this chart in [@fig:best_gantt_rls].  

\rel.figure{gantt_rls}{The Gantt charts corresponding to the median results of the randomized local search&nbsp;`rls`.}{gantt_rls.svgz}{width=99.9%}

\rel.figure{best_gantt_rls}{The optimal Gantt chart found by&nbsp;`rls` for&nbsp;`ta70`.}{best_gantt_rls.svgz}{width=99.9%}

The small change from accepting only better solutions to accepting all solutions that are no worse had a huge impact on performance.
RLS can only have advantages over the hill climber if neutral moves that do not change the objective value exist.
From our results, we can conclude that the networks of such "neutral" search moves allow our local search to escape from local optima on the JSSP.
Next we could investigate whether restarting `rls` can further improve the performance.
We tested restarts already twice in this chapter.
Therefore, we leave this as an exercise for the interested reader. 


### Summary

In this section, we have learned about our first "reasonable" optimization methods.
The stochastic hill climbing algorithm remembers the best-so-far point in the search space.
In each step, it applies the unary operator to obtain a similar but slightly different point.
If it is better, then it becomes the new best-so-far point.
Otherwise, it is forgotten.

The performance of hill climbing depends very much on the unary search operator.
If the operator samples from a very small neighborhood only, like our `swap2` operator does, then the hill climber might quickly get trapped in a local optimum.
A local optimum here is a point in the search space which is surrounded by a neighborhood that does not contain any better solution.
If this is the case, the two conditions for doing efficient restarts may be fulfilled: quick convergence and variance of result quality.

The question when to restart then arises, as we usually cannot find out if we are actually trapped in a local optimum or whether the improving move (application of the unary operator) just has not been discovered yet. 
The most primitive solution is to simply set a limit&nbsp;$L$ for the maximum number of moves without improvement that are permitted.

Our `hcr_L_swap2` was born.
We configured&nbsp;$L$ in a small experiment and found that $L=32768$ seemed to be reasonable.
The setup `hcr_32768_swap2` performed much better than `hc_swap2`.
It should be noted that our experiment used for configuration was not very thorough, but it should suffice at this stage.
We can also note that it showed that different settings of $L$ are better for different instances.
This is probably related to the corresponding search space size &ndash; but we will not investigate this any further here.

A second idea to improve the hill climber was to use a unary operator spanning a larger neighborhood, but which still most often sampled solutions similar to current one.
The `swapn` operator gave better results than than the `swap2` operator in the basic hill climber.
The take-away message is that different search operators may (well, obviously) deliver different performance and thus, testing some different operators can always be a good idea.

We then tried to combine our two improvements, restarts and better operator, into the `hcr_L_swapn` algorithm.
Here we learned the lesson that performance improvements do not necessarily add up.
If we have a method that can deliver an improvement of 10% of solution quality and combine it with another one delivering 15%, we may not get an overall 25% improvement.
Indeed, our `hcr_65536_swapn` algorithm did not really perform significantly better than `hcr_32768_swap2`.

Finally, we tested accepting all solutions that are *not worse* instead of accepting only solutions that are *better* in our local searches.
We obtained the random local search (RLS) algorithm, which differs only in this aspect from the hill climber.
We found that it performed much better on the JSSP even compared to the hill climber with restarts.

From this chapter, we also learned one more lesson:
Many optimization algorithms have parameters.
Our hill climber with restarts had two: the unary operator and the restart limit&nbsp;$L$.
Configuring these parameters well can lead to significant improvements.
