## Scalability

Every problem instance has a certain "size"&nbsp;$s$.
For example, the size of an instance of the Job Shop Scheduling Problem (JSSP) is determined by the number of jobs&nbsp;$\jsspJobs$ and machines&nbsp;$\jsspMachines$.
The bigger the size of the instance, the longer will algorithms need to reach a certain goal.
If we want to sort $s$&nbsp;numbers, for examples, then the time we are going to need with general sorting methods will be in&nbsp;$\bigO(s\log{s})$&nbsp;[@F2007SSIPWOCAOM].
The more items we want to sort, the longer it is going to take.
The same holds for optimization problems like the JSSP:
The more machines and jobs we have, the longer we will need to get a good solution.

There are two ways in which this hits us:
First, there are theoretical limitations on how long it will take or how much memory we will need if we want to solve the problem *exactly* or guarantee to reach a certain solution quality.
Second, algorithms will slow down, i.e., need more time per iteration, on large problems also simply because there are more variables to consider.


### The Problem: $\NPprefix$-Hardness and Runtime {#sec:nphardnessAndRuntime}

Most of the problems that we try to solve with metaheuristic algorithms are (at least) $\NPprefix$-hard.
Sometimes we know this, as in the case of the JSSP, satisfiability tasks, or the Traveling Salesperson Problem (TSP).
Sometimes we can reasonably assume that this will hold, e.g., in special cases of the above or if different such problems are combined, e.g., in combinations of packing problem with a vehicle routing problems that we may encounter in a logistics scenario.

At the current state of research, we can assume:
Any algorithm that can *guarantee* to always find the globally optimal solution of such an ($\NPprefix$-hard) problem will require *exponential* runtime in the *worst case*.
What does this mean?


#### $\NPprefix$-Hardness

Basically, the most important class of problems that is hard to solve is called $\NPprefix$-hard.
We will only briefly discuss this here and the reader is referred to&nbsp;[@F2009TSOTPVNP] for further reading. 

\definition{def}{nProblems}{A problem belongs to the *class&nbsp;$\Pprefix$* if it can be solved in a time which is a polynomial of the problem instance size.}

For example, sorting of numbers is a problem in&nbsp;$\Pprefix$&nbsp;[@F2007SSIPWOCAOM] and so is finding paired matchings&nbsp;[@E1965PTAF].

\definition{def}{npProblems}{A problem belongs to the *class&nbsp;$\NPprefix$* if we can validate its solution in polynomial time of the problem instance size.}

If a solution for such a problem is given, then we can check this solution efficiently.
Of course, all problems from the class&nbsp;$\Pprefix$ are also in&nbsp;$\NPprefix$.
The other way around is not clear as of *yet*, but most likely there are many problems in&nbsp;$\NPprefix$ that are not in&nbsp;$\Pprefix$&nbsp;[@F2009TSOTPVNP].
In other words, $\NPprefix$ contains problems that we (most likely) cannot solve in polynomial time.

\definition{def}{nphard}{A problem is *$\NPprefix$-hard* if an algorithm for solving it can be translated into one for solving any $\NPprefix$-problem in polynomial time.}

There are problems that are $\NPprefix$-hard but are not in class&nbsp;$\NPprefix$.
Good examples for this are $\NPprefix$-hard optimization problems.
For a given TSP instance&nbsp;$\instance$, we can define the decision problem "Is there a tour no longer than&nbsp;$l$?"
We could solve this question by translating it to the optimization problem "Find the shortest tour for&nsp;$\instance$."
This translation does not require any work.
We could obtain the tour&nbsp;$\globalOptimum{\solspel}$.
If its length is less or equal to&nbsp;$l$, then the answer is "yes", otherwise "no".
To verify this, we can compute the tour length, which takes linear time.
Thus, we can fulfill \def.ref{npProblems}. 

Doing it the other way around, however, is not possible:
We cannot verify an answer to the optimization version of the TSP in polynomial time.
Given a tour&nbsp;$\solspel$, we cannot check in polynomial time whether it is optimal or not.
Hence, the optimization version of the TSP is not in&nbsp;$\NPprefix$. 

\def.ref{nphard} can tells us that $\NPprefix$-hard means "at least as hard as any $\NPprefix$-problem."&nbsp;[@W2021NHP]
But $\NPprefix$-hard problems may be harder than the problems in&nbsp;$\NPprefix$.
EXPSPACE-hard problems, for instance, are (thought to be) much harder than  problems that are $\NPprefix$-hard problems that are in&nbsp;$\NPprefix$&nbsp;[@dM2003CCOATP].
Some air travel planning problems fall into this category&nbsp;[@dM2003CCOATP].


#### Guarantee to Find the Optimal Solution

The next ingredient in the high runtime requirement for solving $\NPprefix$-hard problems is the *guaranteed optimality*.

\definition{def}{exactAlgorithm}{An *exact algorithm* will always find the globally optimal solution *and* provides a proof that there cannot be any better solution when reaching its proper termination point if applied to a problem instance.&nbsp;[@MRS2021ATEOPBABA]}

A metaheuristic algorithm may also find the best possible solution of a problem.
But it usually cannot guarantee that there is no better solution elsewhere in the search space.
And this is important:
We can only claim that we have the globally optimal solution if we know for certain that there is no better solution elsewhere.

One simple idea to achieve this would be to enumerate all possible solutions.
If we do this, we will sooner or later encounter the global optimum.
However, only after we have finished the complete enumeration, we really know that this indeed was the global optimum.
Exact algorithms, of course, do this in a more clever way.

However, exact algorithms often may discover the final optimal solution relatively early on.
But they may need a long time to rule out that there cannot be any other, better solution.

One more issue is that the complexity problem does not only hold for seeking the *optimal* solution.
For some problems, even guaranteeing to find a solution not worse than the optimum by a certain *factor* incurs this problem&nbsp;[@MS2011HOAFAJSSP] (see [@sec:jssp:termination]).


#### Exponential Runtime

The current state of research is this:
The time that the algorithm needs until it is finished grows exponentially with the input size.
*Finished* refers to producing the two items mentioned in the previous section, the optimal solution and the proof of optimality.

Well, technically, *exponentially* is the wrong term.
It should actually be *superpolynomial*.
Super-polynomial means that we cannot write any polynomial, i.e., any equation $T\leq s^k$, where $T$&nbsp;be the runtime, $s$&nbsp;the input size, and $k$&nbsp;a constant natural number.

This does not rule out that there might be some very efficient super-polynomial but not-yet-exponential runtime.
For example, there could theoretically be an algorithm with a runtime of&nbsp;$s^{\bigO(\log{s})}$ for 3SAT problems&nbsp;[@CFKLMPPS2015LBBOTETH].
However, at the current state of research, this seems unlikely&nbsp;[@CFKLMPPS2015LBBOTETH].

All of that being said:
It might be possible that we one day can discover an algorithm that can solve $\NPprefix$-hard problems in polynomial runtime.
Then, almost everything is this book will become obsolete.
This would be very sad for me.
Luckily, right now, it does not look like it. 
  

#### Worst Case
 
The exponential runtime claim above of course only holds for worst-case scenarios.

For example, in the TSP, we want to find the shortest round-trip tour through $s$&nbsp;cities (see [@fig:tsp_china]).
If we want to be able to guarantee to find the optimal solution for any possible TSP instance, we will have to assume worst-case exponential runtime.
However, there might be TSP instances that are very easy to solve.
Imagine an instance where all the cities are located on a circle.
Or one where all cities are on a straight line.
Then we can very quickly obtain the optimal solution and we will also know that it is optimal.

Imaging a JSSP where all jobs visit all machines in the same sequence and have the same runtimes on every machine.
We can directly write down the optimal solution, as any solution will be optimal.
We also may know that it is optimal from computing the lower bound of the makespan.

In many cases, even general exact methods might solve the problem very fast and may be able to quickly prove the optimality of the results.
So sometimes, maybe even often, we may be lucky and have a quick runtime when using an exact algorithm.
In general, the runtime needed to solve the problems to optimality will grow exponentially. 
  

### Countermeasures

The main problem statement was:
"Any algorithm that can *guarantee* to always find the globally optimal solution of such an ($\NPprefix$-hard) problem will require *exponential* runtime in the *worst case*."
Basically, we can mitigate the runtime problem by dropping any part of the sentence.

1. Metaheuristics circumvent some of the problems above by simply not guaranteeing to find the optimal result.
   They usually do not guarantee to reach any solution quality threshold at all.
2. We can maybe accept that the runtime is exponential in the worst case as long as we can get solutions sufficiently fast in the average case.
   For the TSP, for instance, the Concorde tool is incredibly fast on many relatively large problems.
   If we really encounter a worst-case instance where the runtime is infeasible, then we may just stop the algorithm and give up on that one.
   Getting optimal solutions 99% of the time may be good enough.
3. We can also break the statement by using exact algorithms that are anytime algorithms (see \def.ref{anytimeAlgorithm}) as heuristics:
   As mentioned earlier, exact algorithms often find the optimal solution early, but spend much time in searching the rest of the search space to make sure that there is not any better solution lurking elsewhere.
   We may terminate exact algorithms earlier if necessary and take their current best result&nbsp;[@WO2013ABABAFQCSFD].
   We lose the guaranteed optimality, but the result we get could still be optimal.
   This goes especially well in combination with the second point above.


### The Problem: Lack of Scalability

*Any* algorithm will need more time if the number of decision variables grows for any (non-trivial) problem.
In other words, the *"curse of dimensionality"*&nbsp;[@B1957DP; @B1961ACPAGT] will also strike metaheuristics that give no guarantee about the result quality.


### Summary

There is one more pitfall that lurks in the problem of how our algorithms scale with the problem size.
Sometimes, a researcher may realize that doing experiments on large-scale problems will take a long time.
They may decide to test their algorithms only on small-scale problems.
This has been identified as a bad practice more than fifty years ago already&nbsp;[@I1971OTEOSFCAP].
The performance observed in experiments with small problems does not necessarily carry over to practical (larger) problems.  
