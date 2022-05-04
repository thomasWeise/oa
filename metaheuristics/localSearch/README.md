## Simple Local Searches

Our first algorithm, random sampling, is not very efficient.
It does not make any use of the information it "sees" during the optimization process.
Each search step consists of creating an entirely new, entirely random candidate solution.
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

This means that if we have a good candidate solution, then there may exist similar solutions which are even better.
We can try to find one of them and then continue trying to do the same from there.

Local search algorithms&nbsp;[@HS2005SLSFAA; @WGOEB] offer one idea for how to do that.
They remember one point&nbsp;$\sespel$ in the search space&nbsp;$\searchSpace$.
In every step, a local search algorithm investigates $g\geq1$ points&nbsp;$\sespel'$ which are derived from and are similar to&nbsp;$\sespel$.
From the joined set of these $g$&nbsp;points&nbsp;$\sespel'$ and&nbsp;$\sespel$, only one point is chosen as the (new or old)&nbsp;$\sespel$.
All the other points are discarded.
This step is repeated again and again.

Local search exploits a property of many optimization problems which is called *causality.


### Ingredient: Unary Search Operation for the JSSP {#sec:jssp:swap2}

For now, let us limit ourselves to local searches creating&nbsp;$g=1$ new point in each iteration.
The question arises how we can create a candidate solution which is similar to, but also slightly different from, one that we already have?
Our search algorithms are working in the search space&nbsp;$\searchSpace$.
So we need one operation which accepts an existing point&nbsp;$\sespel\in\searchSpace$ and produces a slightly modified copy of it as result.
In other words, we need to implement a unary search operator!

On a JSSP with $\jsspMachines$&nbsp;machines and $\jsspJobs$&nbsp;jobs, our representation&nbsp;$\searchSpace$ encodes a schedule as an integer array of length&nbsp;$\jsspMachines*\jsspJobs$ containing each of the job IDs from&nbsp;$0$ to&nbsp;$(\jsspJobs-1)$ exactly $\jsspMachines$&nbsp;times.
The sequence in which these job IDs occur then defines the order in which the jobs are assigned to the machines, which is realized by the encoding function&nbsp;$\encoding$ (see [@lst:jssp_encoding]).

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


\git.code{mp}{Op1Swap2}{A unary search operator that swaps two elements in a permutation (that may contain repeated elements).}{moptipy/operators/permutations/op1_swap2.py}{}{book}{doc,comments}


We implemented this operator in [@lst:Op1Swap2].
Notice that the operator is randomized, i.e., applying it twice to the same point in the search space will likely yield different results.
