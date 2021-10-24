## The Solution Space {#sec:solutionSpace}

### Definitions

As stated in \def.ref{optimizationProblemEconomical}, an optimization problem asks us to make a choice between different possible solutions.
We call them *candidate solutions*.

\definition{def}{candidateSolution}{A *candidate solution*&nbsp;$\solspel$ is one potential solution of an optimization problem.}

\definition{def}{solutionSpace}{The *solution space*&nbsp;$\solutionSpace$ of an optimization problem is the set of all of its candidate solutions&nbsp;$\solspel\in\solutionSpace$.}

Basically, the input of an optimization algorithm is the problem instance&nbsp;$\instance$ and the output would be (at least) one candidate solution&nbsp;$\solspel\in\solutionSpace$.
This candidate solution is the choice that the optimization process proposes to the human operator.
It therefore holds all the data that the human operator needs to take action, in a form that the human operator can understand, interpret, and execute.
During the optimization process, many such candidate solutions may be created and compared to find and return the best of them.

From the programmer's perspective, the solution space is again a data structure, e.g., a `class` in Python.
An instance of this data structure is the candidate solution.

### Example: Job Shop Scheduling

What would be a candidate solution to a JSSP instance as defined in [@sec:jsspInstance]?
Recall from [@sec:jsspExample] that our goal is to complete the jobs, i.e., the production tasks, as soon as possible.
Hence, a candidate solution should tell us what to do, i.e., how to process the jobs on the machines.

#### Idea: Gantt Chart {#sec:jssp:gantt}

This is basically what Gantt chart&nbsp;[@W2003GCACA; @K2000SORCP] are for, as illustrated in [@fig:gantt_demo_without_makespan].
A Gantt chart defines what each of our&nbsp;$\jsspMachines$ machines has to do at each point in time.
The operations of each job are assigned to time windows on their corresponding machines.
