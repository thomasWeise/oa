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

From the perspective of a Python programmer, the general concept of objective functions can be represented by the class given in [@lst:Objective].
The `evaluate` function of this class accepts one instance&nbsp;`x` of the solution space and returns a numerical value.
We can implement this function in any way we want, meaning that we can accommodate all types of solution spaces and optimization goals.

\git.code{mp}{Objective}{A generic interface for objective functions.}{moptipy/api/objective.py}{}{book}{doc,hints}


### Example: Job Shop Scheduling {#sec:jsspObjectiveFunction}

What could be a suitable objective function for the JSSP?
As stated in [@sec:jsspExample], our goal is to complete the production jobs as soon as possible.

\definition{def}{makespan}{In manufacturing, the *makespan* is the time difference between the start and finish of a sequence of jobs or tasks.}

Since we assume that all jobs begin at time index&nbsp;0 in our Gantt charts, the makespan is the time when the last operation of the last job is finished.
Obviously, the smaller this value, the earlier we are done with all jobs, the better is the plan.
The makespan is therefore subject to minimization.
As illustrated in [@fig:gantt_demo_with_makespan], the makespan is the time index of the right-most edge of any of the machine rows/schedules in the Gantt chart.
In the figure, this happens to be the end time&nbsp;230 of the last operation of job&nbsp;0, executed on machine&nbsp;4.

\rel.figure{gantt_demo_with_makespan}{The makespan, i.e., the time when the last job is completed, for the example candidate solution illustrated in [@fig:gantt_demo_without_makespan] for the demo instance from [@fig:jssp_demo_instance].}{gantt_demo_with_makespan.svgz}{width=80%}

Our objective function&nbsp;$\objf$ is thus equivalent to the makespan and subject to minimization.
Based on our candidate solution data structure from [@lst:jssp_gantt], we can easily compute&nbsp;$\objf$.
We simply have to look for the largest number stored in the array `times`, as this array contains the start and end times of all operations of all jobs in the chart.
In [@lst:jssp_makespan], we implement exactly this concept in the easiest possible way.

\git.code{mp}{jssp_makespan}{An implementation of the class [@lst:Objective] to represent the makepan objective function for JSSPs.}{moptipy/examples/jssp/makespan.py}{}{book}{doc,hints}

With this objective function&nbsp;$\objf$, subject to minimization, we have defined that a Gantt chart&nbsp;$\solspel_1$ is better than another Gantt chart&nbsp;$\solspel_2$ if and only if $\objf(\solspel_1)<\objf(\solspel_2)$.^[under the assumption that both are feasible, of course]
