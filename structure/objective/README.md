## Objective Function {#sec:objectiveFunction}

We now know the most important input and output data for an optimization algorithm: the problem instances&nbsp;$\instance$ and candidate solutions&nbsp;$\solspel\in\solutionSpace$, respectively.
But we do not just want to produce some output.
We do not just want to find "any" candidate solution.
We want to find the "good" ones.
For this, we need a measure rating the solution quality.


### Definitions

\definition{def}{objectiveFunction}{An *objective function* $\objf:\solutionSpace\mapsto\realNumbers$ numerically rates the quality of a candidate solution $\solspel\in\solutionSpace$ from the solution space&nbsp;$\solutionSpace$.}

\definition{def}{objectiveValue}{An *objective value* $\objf(\solspel)$ of the candidate solution $\solspel\in\solutionSpace$ is the value that the objective function&nbsp;$\objf$ takes on for&nbsp;$\solspel$.}

\definition{def}{minimization}{An objective function is subject to *minimization* if smaller objective values indicate better solutions.}

\definition{def}{maximization}{An objective function is subject to *maximization* if larger objective values indicate better solutions.}

Without loss of generality, we assume that all objective functions are subject to *minimization*.
In this case, a candidate solution&nbsp;$\solspel_1\in\solutionSpace$ is better than another candidate solution&nbsp;$\solspel_2\in\solutionSpace$ if and only if&nbsp;$\objf(\solspel_1)<\objf(\solspel_2)$.
If&nbsp;$\objf(\solspel_1)>\objf(\solspel_2)$, then&nbsp;$\solspel_2$ would be better and for&nbsp;$\objf(\solspel_1)=\objf(\solspel_2)$, there would be no benefit of either solution over the other, at least from the perspective of the optimization criterion&nbsp;$\objf$.
The minimization scenario fits to situations where&nbsp;$\objf$ represents a cost, a time requirement, or, in general, any number of required resources.
In the Traveling Salesperson Problem (see [@sec:intro:logistics]), for example, a tour is better if it is shorter.

Maximization problems, i.e., where the candidate solution with the higher objective value is better, are problems where the objective function represents profits, gains, or any other form of positive output or result of a scenario.
Maximization and minimization problems can be converted to each other by simply negating the objective function.
In other words, if&nbsp;$\objf$ is the objective function of a minimization problem, we can solve the maximization problem with&nbsp;$-\objf$ and get the same result, and vice versa.
