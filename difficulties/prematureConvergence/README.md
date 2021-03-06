## Premature Convergence {#sec:prematureConvergence}  

\definition{def}{convergence}{An optimization process has converged if it cannot reach new candidate solutions anymore or if it keeps on producing candidate solutions from a small subset of the solution space&nbsp;$\solutionSpace$.}

One of the problems in global optimization is that it is often not possible to determine whether the best solution currently known is situated on local or a global optimum and thus, if convergence is acceptable.
We often cannot even know if the current best solution is a local optimum or not.
In other words, it is usually not clear whether the optimization process can be stopped, whether it should concentrate on refining the current best solution, or whether it should examine other parts of the search space instead.
This can, of course, only become cumbersome if there are multiple (local) optima, i.e., the problem is *multi-modal*.

\definition{def}{multimodality}{An optimization problem is multi-modal if it has more than one local optimum&nbsp;[@R1999ETROLOASPIGS; @HG1995GADATMOTFL; @DJ1975GA; @S1971GOTFFMST].}

The existence of multiple global optima (which, by definition, are also local optima) itself is not problematic.
The discovery of only a subset of them can still be considered as successful in many cases.
The occurrence of numerous local optima, however, is more complicated, as the phenomenon of *premature convergence* can occur.


### The Problem: Convergence to a Local Optimum

\definition{def}{prematureConvergence2}{Convergence to a local optimum is called *premature convergence* ([@WCT2012EOPABT; @WZCN2009WIOD] (see also \def.ref{prematureConvergence}).}

\rel.figure{premature_convergence}{An example for how a hill climber could get trapped in a local optimum when minimizing over a one-dimensional, real-valued search space.}{premature_convergence.svgz}{width=58%}

[@fig:premature_convergence] illustrates how a simple hill climber could get trapped in a local optimum.
In the example, we assume that we have a sub-range of the real numbers as one-dimensional search space and try to minimize a multi-model objective function.
There are more than three optima in the figure, but only one of them is the global minimum.
The optimization process, however, discovers the basin of attraction of one of the local optima first.

\definition{def}{basinOfAttraction}{As *basin of attraction* of a local optimum, we can loosely define the set of points in the search space where applications of the search operators that yield improvements in objective value are likely to guide an optimization process towards that optimum.}

Once the hill climber has traced deep enough into this hole, all the new solutions it can produce are higher on the walls around the local optimum and will thus be rejected (illustrated in gray color).
The algorithm has prematurely converged.


### Countermeasures

What can we do to prevent premature convergence?
Actually, we already learned a wide set of techniques!
Many of them boil down to balancing exploitation and exploration.


#### Restarts

The first method we learned is to simple restart the algorithm if the optimization process did not improve for a long time.
This can help us to exploit the variance in the end solution quality, but whether it can work strongly depends on the number of local optima, the relative size of their basins of attraction, and how many restarts we can perform within the computational budget.
Assume that we have an objective function with $s$&nbsp;optima and that one of which is the global optimum.
Further assume that the basins of attraction of all optima have the same size and are uniformly distributed over the search space.
One would then expect that we need to restart an hill climber about $s$&nbsp;times in average to discover the global optimum.
Unfortunately, there are problems where the number of optima grows exponentially with the dimension of the search space&nbsp;[@HFRA2009RPBBOB2NFD], so restarts alone will often not help us to discover the global optimum.


#### Search Operator Design

To a certain degree we can also combat premature convergence by designing search operators that induce a larger neighborhood.
It is a good idea to have operators that make small moves most of the time and sometimes large moves.
Even a hill climber would have a non-zero probability for escaping a local optimum if it would use such an operator.


#### Investigating Multiple Points in the Search Space at Once

With Evolutionary Algorithms, we attempted yet another approach.
The population, i.e., the $\mu$&nbsp;solutions that an $(\mu+\lambda)$&nbsp;EA preserves, also guard against premature convergence.
While a local search might always fall into the same local optimum if it has a large-enough basin of attraction, an EA that preserves a sufficiently large set of diverse points from the search space may find a better solution.
If we consider using a population, say in a $(\mu+\lambda)$&nbsp;EA, we need to think about its size.
Clearly, a very small population will render the performance of the EA similar to a hill climber:
it will be fast, but might converge to a local optimum.
A large population, say big&nbsp;$\mu$ and&nbsp;$\lambda$ values, will increase the chance of eventually finding a better solution.
This comes at the cost that every single solution is investigated more slowly: In a $(1+1)$-EA, every single function evaluation is spent on improving the current best solution (as it is a hill climber).
In a $(2+1)$-EA, we preserve two solutions and, in average, the neighborhood of each of them is investigated by creating a modified copy only every second FE, and so on.
We sacrifice speed for a higher chance of getting better results.
Populations mark a trade-off.
 
 
#### Diversity Preservation {#sec:prematureConvergence:diversity}

If we have already chosen to use a population of solutions, as mentioned in the previous section, we can add measures to preserve the diversity of solutions in it.
Of course, a population is only useful if it consists of different elements.
A population that has collapsed to only include copies of the same point from the search space is not better than performing hill climbing and preserving only that one single current best solution.
In other words, only that part of the $\mu$&nbsp;elements of the population is effective that contains different points in the search space.
Several techniques have been developed to increase and preserve the diversity in the population&nbsp;[@S2012NIEA; @CLM2013EAEIEAAS; @ST2016DOCAPCASOMFPDIEO], including:

1. Sharing and Niching&nbsp;[@H1975GA; @SK1998FSANMR; @DY1996ENMHINFSAISC] are techniques that decrease the fitness of a solution if it is similar to the other solutions in the population.
   In other words, if solutions are similar, their chance to survive is decreased and different solutions, which are worse from the perspective of the objective function, can remain in the population.
2. Clearing&nbsp;[@P1996ACPAANMFGA; @P1997AEHCTFS] takes this idea one step further and only allows the best solution within a certain radius survive.


#### Sometimes Accepting Worse Solutions

Another approach to escape from local optima is to sometimes accept worse solutions.
This is a softer approach than performing full restarts.
It allows the search to retain some information about the optimization, whereas a "hard" restart discards all knowledge gathered so far.
Examples for the idea of sometimes moving towards worse solutions include:

1. When the Simulated Annealing algorithm creates a new solution by applying the unary operator to its current point in the search space, it will make the new point current if it is better.
   If the new point is worse, however, it may still move to this point with a certain probability.
   This allows the algorithm to escape local optima. 
2. Evolutionary Algorithms do not always have to apply the strict truncation selection scheme "$(\mu+\lambda)$."
   There exist alternative methods, such as
   a. $(\mu,\lambda)$ population strategies, where the $\mu$ current best solutions are always disposed and replaced by the $\mu$ best ones the $\lambda$ newly sampled points in the search space.
   b. When the EAs we have discussed so far have to select some solutions from a given population, they always pick those with the best objective value.
      This is actually not necessary.
      Actually, there exists a wide variety of different selection methods&nbsp;[@GD1990ACAOSSUIGA; @BT1995ACOSSUIGA] such as Tournament selection&nbsp;[@B1980GAFFO; @BT1995ACOSSUIGA], Ranking Selection&nbsp;[@B1980GAFFO; @B1985ASMFGA], or the (discouraged!&nbsp;[@W1989EA; @BT1995ACOSSUIGA; @dlMT1993AAOSPWPAPTPABS]) fitness-proportionate selection&nbsp;[@H1975GA; @GD1990ACAOSSUIGA; @DJ1975GA] may also select worse candidate solutions with a certain probability.
