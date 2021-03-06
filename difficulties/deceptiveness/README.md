## Deceptiveness

Besides causality, another very basic assumption behind metaheuristic optimization is that if candidate solution&nbsp;$\solspel_1$ is better than&nbsp;$\solspel_2$, it is more likely that we can find even better solutions in the neighborhood around&nbsp;$\solspel_1$ than in the neighborhood of&nbsp;$\solspel_2$.
In other words, we assume that following a trail of solutions with improving objective values is in average our best chance of discovering the optimum or, at least, some very good solutions.


### The Problem: Deceptiveness

\rel.figure{increasing_deceptiveness}{An illustration of problems exhibiting increasing deceptiveness (from left to right).}{increasing_deceptiveness.svgz}{width=90%}

A problem is deceptive if following such a trail of improving solutions leads us away from the actual optimum&nbsp;[@WZCN2009WIOD; @WCT2012EOPABT].
[@fig:increasing_deceptiveness] illustrates different problems with increasing deceptiveness of the objective function.

\definition{def}{deceptiveness}{A objective function is *deceptive* (under a given representation and over a subset of the search space) if a hill climber started at any point in this subset will move away from the global optimum.}

\def.ref{deceptiveness} is an attempt to formalize this concept.
We define a specific area&nbsp;$\searchSpaceSubset\subseteq\searchSpace$ of the search space&nbsp;$\searchSpace$.
In this area, we can apply a hill climbing algorithm using a unary search operator&nbsp;$\searchOp$ and a decoding function&nbsp;$\decode:\searchSpace \mapsto \solutionSpace$ to optimize an objective function&nbsp;$\objf$.
If this objective function&nbsp;$\objf$ is deceptive on&nbsp;$\searchSpaceSubset$, then regardless where we start the hill climber, it will move away from the nearest global optimum&nbsp;$\globalOptimum{\sespel}$.
"Move away" here means that we also need to have some way to measure the distance between&nbsp;$\globalOptimum{\sespel}$. and another point in the search space and that this distance increases while the hill climber proceeds.
OK, maybe not a very handy definition after all &ndash; but it describes the phenomena shown in [@fig:increasing_deceptiveness].
The bigger the subset&nbsp;$\searchSpaceSubset$ over which&nbsp;$\objf$ is deceptive, the harder the problem tends to become for the metaheuristics, as they have an increasing chance of searching into the wrong direction.


### Countermeasures

#### Representation Design

From the explanation of the attempted \def.ref{deceptiveness} of deceptiveness, we can already see that the design of the search space, representation mapping, and search operators will play a major role in whether a problem is deceptive or not.

### Benchmarking

It is important to understand how optimization algorithms deal with deceptive problems.
For discrete optimization, the W-Model offers a benchmark problem with tunable deceptive&nbsp;[@WCLW2020SADSOBIFATMPFBBDOA; @WWQLT2018ADCOAAPIBAWATCFEDASAIF; @WW2018DFOCOPATTWMBPFST; @WNSRG2008ATMFMOERANFL].
