## Global Optima and the Lower Bound of the Objective Function

We now know the three key-components of an optimization problem.
We are looking for a candidate solution&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ that has the best objective value&nbsp;$\objf(\globalOptimum{\solspel})$ for a given problem instance&nbsp;$\instance$.
But what is the meaning "best"?


### Definitions

Assume that we have a single objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ defined over a solution space&nbsp;$\solutionSpace$.
This objective function is our primary guide during the search and we are looking for its global optima.

\definition{def}{globalOptimum}{If a candidate solution&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ is a *global optimum* for an optimization problem defined over the solution space&nbsp;$\solutionSpace$, then there is no other candidate solution in&nbsp;$\solutionSpace$ which is better.}

If the objective function is subject to minimization, then each global optimum is a global minimum of the objective function.

\definition{def}{globalMinimum}{For every *global minimum*&nbsp;$\globalOptimum{\solspel}\in\solutionSpace$ of single-objective optimization problem with solution space&nbsp;$\solutionSpace$ and objective function&nbsp;$\objf:\solutionSpace\mapsto\realNumbers$ subject to minimization, it holds that $\objf(\solspel) \geq \objf(\globalOptimum{\solspel}) \forall \solspel \in \solutionSpace$.}

Notice that \def.ref{globalMinimum} does not state that the objective value of&nbsp;$\globalOptimum{\solspel}$ needs to be better than the objective value of all other possible solutions.
The reason is that there may be more than one global optimum, in which case all of them have the same objective value.
Thus, a global optimum is not defined as a candidate solutions better than all other solutions, but as a solution for which no better alternative exists.

The real-world meaning of "globally optimal" is nothing else than "superlative"&nbsp;[@BB2008NO].
If we solve a JSSP for a factory, our goal is to find the *shortest* makespan.
If we try to pack the factory's products into containers, we look for the packing that needs the *least* amount of containers.
If we solve a vehicle routing problem to serve several customers, then we may either want to serve the *most* customers, use the *least* amount of vehicles, or travel the *shortest* overall distance.
Thus, optimization means searching for such superlatives, as illustrated in [@fig:optimization_superlatives].
Vice versa, whenever we are looking for the cheapest, fastest, strongest, best, biggest or smallest "thing", then we have an optimization problem at our hands.

\rel.figure{optimization_superlatives}{Optimization is the search for superlatives&nbsp;[@BB2008NO].}{optimization_superlatives.svgz}{width=60%}

For the JSSP, there exists a simple and fast algorithm that can find the optimal schedules for problem instances with exactly&nbsp;$\jsspMachines=2$ machines *and* if all&nbsp;$\jsspJobs$ jobs need to be processed by the two machines in exactly the same order&nbsp;[@J1954OTATSPSWSTI].
If our application always falls into a certain special case of the problem, we may be lucky to find an efficient way to always solve it to optimality.
The general version of the JSSP, however, is $\NPprefix$&#8209;hard&nbsp;[@LLRKS1993SASAAC; @CPW1998AROMSCAAA], meaning that we cannot expect to solve it to global optimality in reasonable time.
Then, developing a good (meta-)heuristic algorithm, which cannot provide guaranteed optimality but will give close-to-optimal solutions in practice, is a good choice.


### Bounds of the Objective Function

If we apply an approximation algorithm, then we do not have the guarantee that the solution we get is optimal.
Usually, we do not even know if the best solution we currently have is optimal or not.
The most basic mistake that we can read in papers on optimization again and again is this:
The claim that a metaheuristic returns optimal solutions (without further proof or considerations such as those below).
It does not.
None of them do.
They can return good solutions, maybe better solutions than what we can get with any other algorithm within acceptable runtime.
But we usually do not know if a solution is optimal or not.

Well.
Usually.
But not always. 

In some cases, we be able to compute a *lower bound*&nbsp;$\lowerBound(\objf)$ for the objective value of an optimal solution.
We then know that it is not possible that any solution can have a quality better than $\lowerBound(\objf)$.
We may not know, however, whether a solution actually exists that has quality&nbsp;$\lowerBound(\objf)$."
Having a lower bound therefore is not directly useful for solving the problem.
Still, it can at least tell us whether our method for solving the problem is good.
For instance, if we have developed an algorithm for approximately solving a given problem and we the qualities of the solutions we get are close to a the lower bound, then we know that our algorithm is good.
If we even find a solution whose quality equals the lower bound, then we a)&nbsp;know that it is optimal and b)&nbsp;can stop our algorithm immediately, as we cannot further improve on this.
We then know that improving the result quality of the algorithm may be hard, maybe even impossible, and probably not worthwhile.
However, if we cannot produce solutions as good as or close to the lower quality bound, this does not necessarily mean that our algorithm is bad.

It should be noted that it is *not* necessary to know the bounds of objective values.
Lower bounds are a *"nice to have"* feature allowing us to better understand the performance of our algorithms.


### Example: Job Shop Scheduling {#sec:jssp:lowerBounds}

We have already defined our solution space&nbsp;$\solutionSpace$ for the JSSP in [@lst:jssp_gantt] and the objective function&nbsp;$\objf$ in [@lst:jssp_makespan].
A Gantt chart with the shortest possible makespan is then a global optimum.
There may be multiple globally optimal solutions, which then would all have the same makespan.

When facing a JSSP instance&nbsp;$\instance$, we do not know whether a given Gantt chart is the globally optimal solution or not, because we do not know the shortest possible makespan.
There is no direct way in which we can compute it.
But we can, at least, compute some *lower bound*&nbsp;$\lowerBound(\objf)$ for the best possible makespan.

For instance, we know that a job&nbsp;$\jsspJobIndex$ needs at least as long to complete as the sum&nbsp;$\sum_{\jsspMachineIndex=0}^{\jsspMachines-1} \jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}$ over the processing times of all of its operations.
It is clear that no schedule can complete faster then the longest job.
So we already have one lower limit.

Furthermore, we know that the makespan of the optimal schedule also cannot be shorter than the latest "finishing time" of any machine&nbsp;$\jsspMachineIndex$.
This finishing time is at least as big as the sum&nbsp;$\jsspMachineRuntime{\jsspMachineIndex}$ of the runtimes of all the operations for this machine.
But we can refine this:
Each machine may have some least initial idle time&nbsp;$\jsspMachineStartIdle{\jsspMachineIndex}$:
If the operations for machine&nbsp;$\jsspMachineIndex$ never come first in their job, then for each job, we need to sum up the runtimes of the operations coming before the one on machine&nbsp;$\jsspMachineIndex$.
The least initial idle time&nbsp;$\jsspMachineStartIdle{\jsspMachineIndex}$ is then the smallest of these sums.
This may be&nbsp;0, if there is at least one job that first goes to the machine, or greater than zero if no such job exists.
Similarly, each machine has a least idle time&nbsp;$\jsspMachineEndIdle{\jsspMachineIndex}$ at the end.
This is greater than zero if there is no job whose last operation is on the machine.
Then, whenever the last job assigned to the machine has been processed by it, it still needs to go to go elsewhere and the machine must always remain idle for some time at the end of the schedule.
As lower bound for the fastest schedule that could theoretically exist, we therefore get:

$$ \lowerBound(\objf) = \max\left\{\max_{\jsspJobIndex}\left\{ \sum_{\jsspMachineIndex=0}^{\jsspMachines-1} \jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}\right\} \;,\; \max_{\jsspMachineIndex} \left\{ \jsspMachineStartIdle{\jsspMachineIndex}+\jsspMachineRuntime{\jsspMachineIndex} +\jsspMachineEndIdle{\jsspMachineIndex}\right\}\right\} $$ {#eq:jsspLowerBound}

\git.code{mp}{jssp_makespan_lb}{An implementation of Taillard's algorithm&nbsp;[@T199BFBSP] represented in [@eq:jsspLowerBound] to compute the lower bound of the makespan of a JSSP instance.}{moptipy/examples/jssp/instance.py}{}{lb}{comments}

The idea of [@eq:jsspLowerBound] is implemented in [@lst:jssp_makespan_lb], following the ideas from&nbsp;[@T199BFBSP].
Now, we do not know whether it is actually possible to find a schedule whose makespan equals the lower bound.
There simply may not be any way to arrange the jobs such that no operation stalls any other operation too much.
This is why the value&nbsp;$\lowerBound(\objf)$ is called lower bound:
We know no solution can be better than this, but we do not know whether a solution with such minimal makespan exists.

However, if our algorithms produce solutions with a quality close to&nbsp;$\lowerBound(\objf)$, we know that we are doing well.
Also, if we would actually find a solution with that makespan, then we would know that we have perfectly solved the problem.
