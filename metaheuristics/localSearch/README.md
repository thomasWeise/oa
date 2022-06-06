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

: The results of the hill climber with restarts `hcr` with $L=32'768$ and the `swap2` operator compared to those of the basic hill climber&nbsp;`hc`, random sampling algorithm&nbsp;`rs` and  to the lower bound&nbsp;$\lowerBound(\objf)$ of the makespan&nbsp;$\objf$: the best and mean result quality and its standard deviation ($\minBestF$, $\meanBestF$, $\stddevBestF$), the mean of the scaled result quality $\meanBestFscaled$, as well as the mean of the milliseconds when the last improvement took place in the runs ($\meanLIFE$, $\meanLIMS$). The summary line at the bottom presents the best, geometric mean, worst, and standard deviation of the scaled result quality over all runs on all instances ($\minBestFscaled$, $\geomeanBestFscaled$, $\maxBestFscaled$), as well as $\meanLIFE$ and $\meanLIMS$. See [@sec:statisticalMetrics] for more details. {#tbl:end_results_hcr}

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
