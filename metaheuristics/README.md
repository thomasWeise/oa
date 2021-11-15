# Metaheuristic Optimization Algorithms {#sec:metaheuristics}

Optimization problems are solved by optimization algorithms.
We can roughly divide these into *exact* and *heuristic* methods.

An exact algorithm guarantees that it will find the optimal solution if sufficient runtime is granted.
This required runtime might, in the worst case, exceed what we can afford, in particular for $\NPprefix$-hard problems, such as the JSSP.
Many exact methods, however, can also be stopped before completing their run and they can then still provide an approximate solution (without the guarantee that it is optimal).

For heuristic algorithms, this directly is the basic premise;
They give us some approximate solution relatively quickly.
Often they do not make any guarantees at all how good it will be.
Sometimes they provide some bound guarantee, such as "This solution will not cost more than two times of the optimal cost."
Simple heuristics are usually tailor-made for specific problems, like the TSP or JSSP.
Metaheuristics, however, are more general.

\definition{def}{metaheuristic}{A *metaheuristic* is a general algorithm that can produce approximate solutions for a class of different optimization problems.}

Metaheuristics&nbsp;[@WGOEB; @GP2010HOM; @GK2003HOM; @CT2018AITMFO] are the most important class of algorithms that we explore in this book.
These algorithms have the advantage that we can easily adapt them to new optimization problems.
As long as we can construct the elements discussed in [@sec:structure] for a problem, we can attack it with a metaheuristic.
We will introduce several such general algorithms in this book.
We explore them by again using the Job Shop Scheduling Problem (JSSP) from [@sec:jsspExample] as example.

\rel.input{common/README.md}
\rel.input{randomSampling/README.md}
