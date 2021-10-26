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

\rel.figure{gantt_demo_without_makespan}{One example candidate solution for the demo instance given in [@fig:jssp_demo_instance]: A Gantt chart assigning a time window to each job on each machine.}{gantt_demo_without_makespan.svgz}{width=80%}

The Gantt chart contains one row for each machine.
It is to be read from left to right, where the x-axis represents the time units that have passed since the beginning of the job processing.
Each colored bar in the row of a given machine stands for a job and denotes the time window during which the job is processed.
The bar representing operation&nbsp;$\jsspMachineIndex$ of job&nbsp;$\jsspJobIndex$ is painted in the row of machine&nbsp;$\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}$ and its length equals the time requirement&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}$.

[@fig:gantt_demo_without_makespan] illustrates one example solution of our `demo` instance as such a Gantt chart.
We use a distinct color for each job.
This chart defines that job&nbsp;0 starts at time unit&nbsp;0 on machine&nbsp;0 and is processed there for ten time units.
Then the machine idles until the 70th time unit, at which point it begins to process job&nbsp;1 for another ten time units.
After 15&nbsp;more time units of idling, job&nbsp;3 will arrive and be processed for 20&nbsp;time units.
Finally, machine&nbsp;0 works on job&nbsp;2 (coming from machine&nbsp;3) for ten time units starting at time unit&nbsp;150.

Machine&nbsp;1 starts its day with an idle period until job&nbsp;2 arrives from machine&nbsp;2 at time unit&nbsp;30 and is processed for 20&nbsp;time units.
It then processes jobs&nbsp;1 and&nbsp;0 consecutively and finishes with job&nbsp;3 after another idle period.
And so on.

If we wanted to create a Python class to represent the complete information from a Gantt diagram, it could look like [@lst:jssp_gantt].
An instance of our `Gantt` class holds a reference to the JSSP instance (see [lst:jssp_instance]).
Furthermore, it holds a three dimensional array `times`, which has one row for each of the $\jsspJobs$&nbsp;jobs.
Each job-row has one column for each of the $\jsspMachines$&nbsp;operations of the job (there is one operation for each of the $\jsspMachines$&nbsp;machines).
Each of these columns, in turn, stores the start and the end time of the operation of that job on this machine.
Actually, we do not necessarily need to store the end times as well, because we know how long each operation takes based on the instance data so only having the start times stored would be sufficient &hellip; but it will make our life a bit easier here and save us some look-ups, so we will settle for this format.
This way, we can store all the data needed to represent and/or plot a Gantt chart in one object.

\git.code{mp}{jssp_gantt}{Excerpt from a Python class for representing the data of a candidate solution to a JSSP.}{moptipy/examples/jssp/gantt.py}{}{book}{}

The `times` for the `Gantt` instance corresponding to [@fig:gantt_demo_without_makespan] would look as follows:
For job&nbsp;0 and operation&nbsp;0, it would hold `[0, 10]` since this operation indeed takes place during the first 10&nbsp; time units of the schedule.
For operation&nbsp;1 of the job (which is executed on machine&nbsp;1) it holds `[70, 90]`, for operation&nbsp;2 (on machine&nbsp;2), we get `[160,180]`, for operation&nbsp;3 (on machine&nbsp;3), we find `[180,220]`, and for operation&nbsp;4 (which is the last operation and takes place on machine&nbsp;4), we get `[220,230]`.

\rel.code{jssp_example_solution_times}{The contents of the `times` array of an instance of `Gantt` (see [lst:jssp_gantt]) representing the solution illustrated in [@fig:gantt_demo_without_makespan].}{jssp_example_solution_times.py}{}{}{format}

More interesting are the contents for job&nbsp;2.
Its first operation will be executed on machine&nbsp;2, where it can actually start immediately.
This is signified by its third component array having values `[0, 30]`.
It will arrive at machine&nbsp;0 much later, after having passed through all other machines.
Its values for the operation on this machine, which come first in its component array, are `[150, 160]`.
The complete array contents are illustrated in [@lst:jssp_example_solution_times].
