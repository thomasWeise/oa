## Large Instance Sizes are Bad for Performance

Every problem instance has a certain "size"&nbsp;$s$.
For example, the size of an instance of the Job Shop Scheduling Problem (JSSP) is determined by the number of jobs&nbsp;$\jsspJobs$ and machines&nbsp;$\jsspMachines$.
The bigger the size of the instance, the longer will algorithms need to reach a certain goal.
If we want to sort $s$&nbsp;numbers, for examples, then the time we are going to need with general sorting methods will be in&nbsp;$\bigO(s\log{s})$&nbsp;[@F2007SSIPWOCAOM].
The more items we want to sort, the longer it is going to take.
The same holds for optimization problems like the JSSP:
The more machines and jobs we have, the longer we will need to get a good solution.

There are three ways in which this hits us:
First, there are theoretical limitations on how long it will take or how much memory we will need if we want to solve the problem *exactly* or guarantee to reach a certain solution quality.
Second, algorithms will slow down, i.e., need more time per iteration, on large problems also simply because there are more variables to consider.
Third, the solutions we will obtain with metaheuristics will get comparatively worse when the problem becomes larger.


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

\definition{def}{exactAlgorithm}{An *exact algorithm* will always find the globally optimal solution *and* provides a proof that there cannot be any better solution when reaching its proper termination point if applied to a problem instance.&nbsp;[@MRS2021ATEOPBABA; @CS2000SAOCTOAAH]}

A metaheuristic algorithm may also find the best possible solution of a problem.
But it usually cannot guarantee that there is no better solution elsewhere in the search space.
And this is important:
We can only claim that we have the globally optimal solution if we know for certain that there is no better solution elsewhere.

One simple idea to achieve this would be to enumerate all possible solutions.
If we do this, we will sooner or later encounter the global optimum.
However, only after we have finished the complete enumeration, we really know that this indeed was the global optimum.
Exact algorithms, of course, do this in a more clever way.

Exact algorithms often may discover the final optimal solution relatively early on.
Yet, they may need a long time to rule out that there cannot be any other, better solution.
Branch and bound, for example, may first discover some solution, then the optimal solution, and then need a longer time to prove the optimality&nbsp;[@OD2011AAODFSFCO].

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
  

### Countermeasures against $\NPprefix$-Hardness

Well, we cannot do anything against $\NPprefix$-Hardness.
If we were able to solve find an efficient algorithm for $\NPprefix$-Hard problems, we would win all sorts or prestigious awards, like the [Millenium Prize](https://www.claymath.org/millennium-problems/millennium-prize-problems)&nbsp;[@C2021PVNPTMPP].
However, even for $\NPprefix$-hard problems, we may obtain good solutions.
Remember that the main problem statement was that
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


### The Problem: Bad Scaling with Instance Size

*Any* algorithm will need more time if the number of decision variables grows for any (non-trivial) problem, because its fundamental operations, such as objective function evaluations and copying of solutions, get slower.
But also the quality of the solutions we can get within a given time frame usually gets worse.
The reason is that the search space often grows exponentially with the number of decision variables.

Solving an optimization problem means to find the right settings for all decision variables.
Let us say that our decision variables each can take on 10&nbsp;different values.
If we have only two decision variables, then we can test all $|\searchSpace|=10^2=100$ possible settings by sampling exactly 100&nbsp;solutions.
For three decision variables, then these 100&nbsp;samples are only enough to test one tenth of the possible settings.
If we have four variables, then only one hundredth of the possible value combinations are tested after 100&nbsp;FEs.
Our algorithms learn less information about the structure of the search space within a fixed number of samples if the number of decision variables increases.
Therefore, they become less likely to spot the really good solutions.    
In machine learning, this phenomenon is called the *"curse of dimensionality"*&nbsp;[@B1957DP; @B1961ACPAGT].
The more features (decision variables) there are, the less  meaningful information can be obtained with a constant number of samples.


### Countermeasures to Improve the Scaling with the Instance Size

#### Parallelization and Distribution

First, we can try to improve the performance of our algorithms by parallelization and distribution.
*Parallelization* means that we utilize multiple CPUs or CPU cores or GPUs on the same machine at the same time.
*Distribution* means that we use multiple computers connected by network.
Using either approach approach makes sense if we already perform "close to acceptable," i.e., if we are not more than one hundred times too slow.

For example, I could try to use the four CPU cores on my laptop computer to solve a JSSP instance instead of only one.
I could, for instance, execute four separate runs of the hill climber or Simulated Annealing in parallel and then just take the best result after two minutes have elapsed.
Matter of fact, I could run four different algorithm setups or four entirely different algorithms at once.
It makes sense to assume that this would give me a better chance to obtain a good solution.
However, it is also clear that, overall, I am still just utilizing the variance of the results.
In other words, the result I obtain this way will not really be better than the results I could expect from the best of setups or algorithms if run alone.

Maybe I need to solve 1000&nbsp;problem instances in 10&nbsp;hour.
On my PC doing this could maybe take 500&nbsp;hours.
Now I could think:
OK, I can do $1000/500=2$ problem instances per hour.
I have only 10&nbsp;hours in total, so I would need to be able to do $1000/10=100$ instances per hour.
So I actually need $100/2=50$&nbsp;PCs to do the job in time.
Each of the 50&nbsp;PCs can do 100&nbsp;instances per hour, meaning that I can complete $10*100=1000$ instances in 10&nbsp;hours.

Both of the above examples work because I use more computer power to conduct multiple runs in parallel.
No communication is necessary between the different runs and I have sufficient time to let each run reach its natural end.
This is the ideal situation.  

One more interesting option is that I could run a metaheuristic together with an exact algorithm which can guarantee to find the optimal solution.
For the JSSP, for instance, there exists an efficient dynamic programming algorithm which can solve several well-known benchmark instances within seconds or minutes&nbsp;[@vH2016DPFRASOSOD; @vHNOG2017ACOTPSTJSSPOBDP; @GvHSGT2010STJSSPOBDP].
Of course, there can and will be instances that it cannot solve.
So the idea would be that in case the exact algorithm can find the optimal solution within the computational budget, we take it.
In case it fails, one or multiple metaheuristics running other CPUs may give us a good approximate solution.

Alternatively, I could take a population-based metaheuristic like an Evolutionary Algorithm and parallelize or distribute in&nbsp;[@CPG2000EPGATAP; @LA2011PGATARWA].
Instead of executing $\nu$&nbsp;independent runs on $\nu$&nbsp;CPU cores, I could divide the offspring generation between the different cores.
In other words, each core could create, map, and evaluate roughly $\lambda/\nu$&nbsp;offsprings.
This would allow me to complete more generations of the algorithm within the same time frame.
Later populations are more likely to find better solutions, but require more computational time to do so. 
By parallelizing them, I thus could utilize this power without needed to wait longer.
Similar approaches can be applied to other population-based algorithms such as Ant Colony Optimization&nbsp;[@GOPBD2022AEACOFFHE] and Differential Evolution&nbsp;[@TPPV2004PDE].
We can also combine different metaheuristics, e.g., let different nodes or CPUs execute different algorithms and exchange candidate solutions among them&nbsp;[@WG2006DAAFFDMOSAATTGPOSN].

However, there is a limit to the speed-up we can achieve with either parallelization or distribution.
Amdahl's Law&nbsp;[@A1967VOTSPATALSCC], in particular with the refinements by Kalfa&nbsp;[@K1988B] shows that we can get at most a sub-linear speed-up.
On the one hand, only a certain fraction of a program can be parallelized and each parallel block has a minimum required execution time (e.g., a block must take at least as long as one single CPU instruction).
On the other hand, communication and synchronization between the&nbsp;$\nu$ involved threads or processes is required, and the amount of it grows with their number&nbsp;$\nu$.
There is a limit value for the number of parallel processes&nbsp;$\nu$ above which no further runtime reduction can be achieved.
In summary, when battling an exponential growth of the search space size with a sub-linear gain in speed, we will hit certain limits, which may only be surpassed by qualitatively better algorithms.


#### Indirect Representations

In several application areas, we can try to speed up the search by reducing the size of the search space.
The idea is to define a small search space&nbsp;$\searchSpace$ which is translated by a function&nbsp;$\encoding:\searchSpace\mapsto\solutionSpace$ to a much larger solution space&nbsp;$\solutionSpace$, i.e., $|\searchSpace|\ll|\solutionSpace|$&nbsp;[@BK1999TWTGDACOEFAEDP; @D2009WAWDINGADS].

The first group of indirect representations uses so-called *generative mappings* assume some underlying structure, usually forms of symmetry, in&nbsp;$\solutionSpace$&nbsp;[@DAS2007ANGEFENNSAOG; @RCON1998GPGE].
When trying to optimize, e.g., the profile of a tire, it makes sense to assume that it will by symmetrically repeated over the whole tire.
Most houses, bridges, trains, car frames, or even plants are symmetric, too.
Many physical or chemical processes exhibit symmetries towards the surrounding system or vessel as well.
Representing both sides of a symmetric solution separately would be a form of redundancy.
If a part of a structure can be repeated, rotated, scaled, or copied to obtain "the whole", then we only need to represent this part.
Of course, there might be asymmetric tire profiles or oddly-shaped bridges which could perform even better and which we would then be unable to discover.
Yet, the gain in optimization speed may make up for this potential loss.

If there are two decision variables $\arrayIndex{\sespel}{1}$ and $\arrayIndex{\sespel}{2}$ and, usually, $\arrayIndex{\sespel}{2}\approx-\arrayIndex{\sespel}{1}$, for example, we could reduce the number of decision variables by one by always setting&nbsp;$\arrayIndex{\sespel}{2}=-\arrayIndex{\sespel}{1}$.
Of course, we then cannot investigate solutions where $\arrayIndex{\sespel}{2}\neq-\arrayIndex{\sespel}{1}$, so we may lose some generality.

Based on these symmetries, indirect representations create a "compressed" version&nbsp;$\searchSpace$ of&nbsp;$\solutionSpace$ of a much smaller size&nbsp;$|\searchSpace|\ll|\solutionSpace|$.
The search then takes place in this compressed search space and thus only needs to consider much fewer possible solutions.
If the assumptions about the structure of the search space is correct, then we will lose only very little solution quality.

A second form of indirect representations is called *ontogenic representation* or *developmental mappings*&nbsp;[@DWT2012ASOSRFEOOGS; @D2009WAWDINGADS; @EL2007DBELOSEI].
They are similar to generative mapping in that the search space is smaller than the solution space.
However, their representational mappings are more complex and often iteratively transform an initial candidate solution with feedback from simulations.
Assume that we want to optimize a metal structure composed of hundreds of beams.
Instead of encoding the diameter of each beam, we encode a neural network that tells us how the diameter of a beam should be changed based on the stress on it.
Then, some initial truss structure is simulated several times.
After each simulation, the diameters of the beams are updated according to the neural network, which is fed with the stress computed in the simulation.
Here, the search space encodes the weights of the neural network&nbsp;$\searchSpace$ while the solution space&nbsp;$\solutionSpace$ represents the diameters of the beams. 
Notice that the size of&nbsp;$\searchSpace$ is unrelated to the size of&nbsp;$\solutionSpace$, i.e., could be the same for 100 or for 1000 beam structures.


#### Exploiting Separability

Sometimes, some decision variables may be unrelated to each other.
If this information can be discovered, the groups of independent decision variables can be optimized separately.
This will then be faster.


### Summary

Problems with many decision variables are always annoying.
It takes longer to create and modify candidate solutions.
Sometimes internal data structures, such as the pheromone matrix in Ant Colony Optimization, grow polynomially with the number of decision variables and occupy much memory for larger problems.
Also, the search space size grows exponentially with the number of decision variables.
This means that we need to sample more solutions to learn about its structure.
Most of the practically relevant problems are $\NPprefix$-hard, which means that finding a guaranteed optimal solution will also take a time growing exponentially with the number of decision variables as well.
These are fundamental problems and there are few techniques we can use to mitigate them.

Moreover, is another pitfall that lurks in the problem of how our algorithms scale with the problem size.
Sometimes, a researcher may realize that doing experiments on large-scale problems will take a long time.
They may decide to test their algorithms only on small-scale problems.
This has been identified as a bad practice more than fifty years ago already&nbsp;[@I1971OTEOSFCAP].
The performance observed in experiments with small problems does not necessarily carry over to practical (larger) problems.  
