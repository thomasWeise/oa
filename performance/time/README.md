## Measuring Time {#sec:measuringTime}

Let us investigate the question:
"What does good optimization algorithm performance mean?"
As a first approximation, we could state that an optimization algorithm performs well if it can solve the optimization problem to optimality.
If two optimization algorithms can solve the problem, then we prefer the faster one.
This brings us to the question what *faster* means.
If we want to compare algorithms, we need a concept of time.


### Clock Time

Of course, we already know a very well-understood concept of time.
We use it every day: the clock time&nbsp;[@CDM1978RCEIMP].
In our experiments with the JSSP, we have measured the runtime mainly in terms of milliseconds that have passed on the clock as well.

\definition{def}{clockTime}{The consumed *clock time* is the time that has passed since the optimization process was started.}

Using the clock to measure the runtime of experiments has several *advantages*:

- Clock time is a quantity which makes physical sense and which is intuitive clear to us.
- In applications, we often have well-defined computational budgets and thus need to know how much time our processes really need.
- Many research works report the consumed runtime, so there is a wide basis for comparisons.
- If we want to publish our work, we should report the runtime that the implementation of our algorithm needs as well.
- If we measure the runtime of our algorithm implementation, it will include everything that the code we are executing does.
  Whether our code loads files, allocates data structures, or does complicated calculations &ndash; everything will be included in the measurement.
- If we can parallelize or even distribute our algorithms, clock time measurements still make sense.

However, reporting the clock time consumed by an algorithm implementation also has *disadvantages*:

- The measured time strongly depends on your computer and system configuration.
  Runtimes measured on different machines or on different system setups are inherently incomparable or, at least, it is easy to make mistakes here.
  The runtime is influenced at least by the CPU type and speed, the memory type, speed, and size, the operating system, the size of caches, and many more aspects of computer performance&nbsp;[@L2000MCPAPG; @M2001EAOA].
  Runtimes that were reported twenty years ago are basically useless now, unless they differ from current measurements very significantly, by orders of magnitudes.
- Runtime measurements also are measurements based on a given *implementation*, not *algorithm*.
  An algorithm implemented in the `C` programming language may perform very different compared to the very same algorithm implemented in `Python`&nbsp;[@M2001EAOA].
  Also, many "components" and data structures used in algorithms can be realized differently, which can have a tremendous impact of the performance of the implementations&nbsp;[@WWLC2019IIIOADTM].
  Remember the different sorting methods you learned in basic computer science classes, for instance.
  An algorithm implementation using a hash map to store and retrieve certain objects may perform entirely different from the same algorithm implemented using a sorted list.
  Hence, effort should be invested to create good implementations before measuring their consumed runtime and, very important, the same effort should be invested into all compared algorithms&hellip;
- Runtime measurements are not always very accurate.
  There may be many effects which can mess up our measurements, ranging from
  + other processes being executed on the same system and slowing down our process&nbsp;[@GHJLSS1977MAAFCDLLAC],
  + delays caused by swapping or paging,
  + time lost when a Just in Time compiler suddenly kicks in to compile a frequently used code piece in our Java or Python programs, to
  + shifts of CPU speeds due to dynamic CPU clocking.
- Runtime measurements are not very precise.
  Often, clocks have resolutions only down to a few milliseconds, and within even a millisecond many action can happen on today's CPUs.

There exist ideas to mitigate the drawback that clock times are hard to compare&nbsp;[@JMG2004EAOHFTS; @WCTLTCMY2014BOAAOSFFTTSP].
The key point is that clock times always lead to measurements of the algorithm *implementation* performance on a specific system.
This can be good, if we design a practical implementation.
It can also be bad, if we perform fundamental research on algorithmic characteristics and want fundamental conclusions about performance that are valid independent of what kind of hardware is used.
Either way:
If we report clock times, then we *must* include a reasonably complete specification of the computer we used in the report as well&nbsp;[@CDM1978RCEIMP].


### Consumed Function Evaluations {#sec:comparing:time:FEs}

Instead of measuring how many milliseconds our algorithm needs, we often want a more abstract measure.
One such idea is to count the so-called (objective) *function evaluations* or FEs for short&nbsp;[@CDM1978RCEIMP].

\definition{def}{fes}{The consumed *function evaluations*&nbsp;(FEs) are the number of calls to the objective function issued since the beginning of the optimization process.}

Performing one function evaluation means to take one point from the search space&nbsp;$\sespel\in\searchSpace$, map it to a candidate solution&nbsp;$\solspel\in\solutionSpace$ by applying the decoding function&nbsp;$\solspel=\decode(\sespel)$, and then computing the quality of&nbsp;$\solspel$ by evaluating the objective function&nbsp;$\objf(\solspel)$.
Usually, the number of FEs is also equal to the number of search operations applied, which means that each FE includes one application of either a nullary, unary, or binary search operator.
Counting the FEs instead of measuring time directly has the following *advantages*:

- FEs are completely machine- and implementation-independent and therefore can more easily be compared.
  If we re-implement an algorithm published 50 years ago, it should still consume the same number of FEs.
- Counting FEs is always accurate and precise, as there cannot be any outside effect or process influencing the measurement (because that would mean that an internal counter variable inside of our process is somehow altered artificially).
- Results in many works are reported based on FEs or in a format from which we can deduce the consumed FEs.
- If we want to publish our research work, we should report the consumed FEs anyway.
- The algorithmic work included in an FE is the most time consuming part of many optimization processes.
  Then, the actual consumed runtime is roughly proportional to the consumed FEs and "performing more FEs" basically equals to "needing more runtime."
- Measured FEs are something like an empirical, simplified version of algorithmic time complexity.
  FEs are inherently close to theoretical computer science, roughly equivalent to "algorithm steps," which are the basis for theoretical runtime analysis.
  For example, researchers who are good at Mathematics can go and derive things like bounds for the "expected number of FEs" to solve a problem for certain problems and certain algorithms&nbsp;[@DN2020TOECRDIDO].
  Doing this with clock time would neither be possible nor make sense.
  But with FEs, it can be possible to compare experimental with theoretical results&nbsp;[@CPD2017TAMPARAOEA].

But measuring time in function evaluations also has some *disadvantages*, namely:

- There is no guaranteed relationship between FEs and real time.
- An algorithm may have hidden complexities which are not "appearing" in the FEs.
  For instance, an algorithm could necessitate a lengthy preprocessing procedure before sampling even the first point from the search space.
  This would not be visible in the FE counter, because, well, it is not an FE.
  The same holds for the selection step in an Evolutionary Algorithm or the pheromone update in Ant Colony Optimization.
  Although these probably are fast procedures, they will be outside of what we can measure with FEs.
- A big problem is that one function evaluation can have extremely different actual time requirements and algorithmic complexity in different algorithms.
  For instance, it is known that in a Traveling Salesperson Problem (TSP)&nbsp;[@ABCC2006TTSPACS; @GP2002TTSPAIV] with $n$&nbsp;cities, some algorithms can create an evaluate a new candidate solution from an existing one within a *constant* number of computational steps, i.e., in&nbsp;$\bigO{1}$, while others need a number of steps growing quadratically with&nbsp;$n$, i.e., are in&nbsp;$\bigO{n^2}$&nbsp;[@WCTLTCMY2014BOAAOSFFTTSP].
  FEs are fair time measures only if the algorithms that we compare have roughly the same time complexity per FE.
- Time measured in FEs is harder to comprehend in the context of parallelization and distribution of algorithms.

An idea to *mitigate* the problem with the different per-FE complexities would be to count algorithm steps in a problem-specific method with a higher resolution.
In&nbsp;[@WCTLTCMY2014BOAAOSFFTTSP], for example, it was proposed to count the number of distance evaluations on the TSP and in&nbsp;[@HWHC2013HILSFM], bit flips are counted on the MAX-SAT problem.

In summary, FEs are the time measure to use for research.
For practical applications, they are less relevant and there, often the clock time is preferred. 


### Do not count generations!

One iteration of a population-based optimization method is called one *generation*.
At first glance, generations seem to be a machine-independent time measure much like FEs.
However, measuring runtime in "generations" is a very bad thing to do.

In one such generation, multiple candidate solutions are generated and evaluated.
How many?
This depends on the population size settings, e.g., $\mu$ and&nbsp;$\lambda$.
So generations are not comparable across different population sizes.

But there are more issues:
Some algorithms do not evaluate new solutions that are identical to their parents.
This would influence the relationship between FEs and generations in an unpredictable way.
If we use algorithm enhancements like clearing&nbsp;[@P1996ACPAANMFGA; @P1997AEHCTFS], then the number of new points sampled from the search space may be different in each generation.
In Memetic Algorithms, local search is applied to either some or all offsprings in a generation, consuming a potentially unpredictable additional amount of FEs.
In other words, the number of consumed generations does not necessarily have a straightforward relationship to FEs (and neither to the actual consumed runtime).
In some algorithms, the population size may change adaptively.
Therefore, counting FEs should always be preferred over counting generations.


### Summary

Both ways of measuring time have advantages and disadvantages.
If we are working on a practical application, then we would maybe prefer to evaluate our algorithm implementations based on the clock time they consume.
When implementing a solution for scheduling jobs in an actual factory or for routing vehicles in an actual logistics scenario, what matters is the real, actual time that the operator needs to wait for the results.
Whether these time measurements are valuable ten years from now or not is not so important.
It also does not matter too much how much time our processes would need if executed on a hardware different from what we have or if they were re-implemented in a different programming language.
And if we re-implement it for a different hardware, then what counts is if that new setup is faster in terms of clock time.

If we are trying to develop a new algorithm in a research scenario, then may counting FEs is more important.
Here we aim to make our results comparable in the long term and we very likely need to compare with results published based on FEs.
Another important point is that a black-box algorithm (or metaheuristic) usually makes very few assumptions about the actual problem to which it will be applied later.
While we tried to solve the JSSP with our algorithms in this book, you probably have seen that we could plug almost arbitrary other search and solution spaces, representation mappings, or objective functions into them.
Thus, we often use artificial problems where FEs can be done very quickly as test problems for our algorithms, because then we can do many experiments.
Measuring the runtime of algorithms solving artificial problems does not make that much sense, unless we are working on some algorithms that consume an unusual amount of time.

That being said, I personally prefer to **measure both FEs and clock time**.
This way, we are on the safe side.
