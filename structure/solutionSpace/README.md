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

\git.code{mp}{jssp_gantt}{Excerpt from a Python class for representing the data of a candidate solution to a JSSP.}{moptipy/examples/jssp/gantt.py}{}{book}{doc}

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

This way to represent Gantt charts as data structures is easy to read, understand, and visualize.
Actually, we could also chose a more compact representation:
We do not necessarily need to store the end times of the operations as well.
We know how long each job&nbsp;$\jsspJobIndex$ needs on any machine&nbsp;$\jsspMachineIndex$ takes based on the instance data&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex'}$.
Thus, having only the start times stored would be sufficient.
Another form of representing a solution would therefore be to just map each operation to a starting time, leading to $\jsspMachines*\jsspJobs$ integer values per candidate solution&nbsp;[@vH2016DPFRASOSOD].
However, also storing the end times of the operations will make our life a bit easier here.
It allows the human operator to directly see what is going on.
She can directly tell each machine or worker what to do and when to do it, without needing to look up any additional information from the problem instance data.


#### Size of the Solution Space {#sec:solutionSpace:size}

We choose the set of all Gantt charts for $\jsspMachines$&nbsp;machines and $\jsspJobs$&nbsp;jobs as our solution space&nbsp;$\solutionSpace$.
Now it is not directly clear how many such Gantt charts exist, i.e., how big&nbsp;$\solutionSpace$ is.
If we allow arbitrary useless waiting times between operations, then we could create arbitrarily many different valid Gantt charts for any problem instance.
Let us therefore assume that no time is wasted by waiting unnecessarily.

There are&nbsp;$\jsspJobs!=\prod_{\jsspJobIndex=1}^{\jsspJobs} \jsspJobIndex$ possible ways to arrange $\jsspJobs$&nbsp;jobs on one machine.
Here, $\jsspJobs!$, called the factorial of&nbsp;$\jsspJobs$, is the number of different permutations (or orderings) of&nbsp;$\jsspJobs$ objects.
If we have three jobs $a$, $b$, and&nbsp;$c$, then there are $3!=1*2*3=6$ possible permutations, namely $(a,b,c)$, $(a,c,b)$, $(b,a,c)$, $(b, c, a)$, $(c, a, b)$, and $(c, b, a)$.
Each permutation would equal one possible sequence in which we can process the jobs on *one* machine.
If we have three jobs and one machine, then six is the number of possible different Gantt charts that do not waste time.

If we would have&nbsp;$\jsspJobs=3$ jobs and&nbsp;$\jsspMachines=2$ machines, we then would have $(3!)^2=36$ possible Gantt charts, as for each of the&nbsp;6 possible sequence of jobs on the first machines, there would be&nbsp;6 possible arrangements on the second machine.
For&nbsp;$\jsspMachines=2$ machines, it is then $(\jsspJobs!)^3$, and so on.
In the general case, we obtain [@eq:jssp_solution_space_size_upper] for the size&nbsp;$\left|\solutionSpace\right|$ of the solution space&nbsp;$\solutionSpace$.

$$ \left|\solutionSpace\right| = (\jsspJobs!)^{\jsspMachines} $$ {#eq:jssp_solution_space_size_upper}

However, the fact that we can generate $(\jsspJobs!)^{\jsspMachines}$ possible Gantt charts without useless delay for a JSSP with&nbsp;$\jsspJobs$ jobs and&nbsp;$\jsspMachines$ machines does not mean that all of them are actual *feasible* solutions.


#### The Feasibility of the Solutions {#sec:solutionSpace:feasibility}

\definition{def}{constraint}{A *constraint* is a rule imposed on the solution space&nbsp;$\solutionSpace$ which can either be fulfilled or violated by a candidate solution&nbsp;$\solspel\in\solutionSpace$.}

\definition{def}{feasibility}{A candidate solution&nbsp;$\solspel\in\solutionSpace$ is *feasible* if and only if it fulfills all constraints.}

\definition{def}{infeasibility}{A candidate solution&nbsp;$\solspel\in\solutionSpace$ is *infeasible* if it is *not feasible*, i.e., if it violates at least one constraint.}

In order to be a feasible solution for a JSSP instance, a Gantt chart must indeed fulfill a couple of *constraints*:

1. all operations of all jobs must be assigned to their respective machines and properly be completed,
2. only the jobs and machines specified by the problem instance must occur in the chart,
3. a operation must be assigned a time window on its corresponding machine which is exactly as long as the operation needs on that machine,
4. the operations cannot intersect or overlap, each machine can only carry out one job at a time,
5. once a machine begins to process an operation, it cannot stop until the operation is complete, i.e., no preemption is possible, and
6. the precedence constraints of the operations must be honored.

While the first five  *constraints* are rather trivial, the latter one proofs problematic.
Imagine a JSSP with&nbsp;$\jsspJobs=2$ jobs and&nbsp;$\jsspMachines=2$ machines.
There are&nbsp;$(2!)^2=(1*2)^2=4$ possible Gantt charts.
Assume that the first job needs to first be processed by machine&nbsp;0 and then by machine&nbsp;1, while the second job first needs to go to machine&nbsp;1 and then to machine&nbsp;0.
A Gantt chart which assigns the first job to be the first on machine&nbsp;1 and the second job first to be the first on machine&nbsp;$0$ cannot be executed in practice, i.e., is *infeasible*, as such an assignment does not honor the precedence constraints of the jobs.
Instead, it contains a deadlock.

\rel.figure{jssp_feasible_gantt}{Two different JSSP instances with&nbsp;$\jsspMachines=2$ machines and&nbsp;$\jsspJobs=2$ jobs, one of which has only three feasible candidate solutions while the other has four.}{jssp_feasible_gantt.svgz}{width=90%}

The third schedule in the first column of [@fig:jssp_feasible_gantt] illustrates exactly this case.
Machine&nbsp;0 should begin by doing job&nbsp;1.
Job&nbsp;1 can only start on machine&nbsp;0 after it has been finished on machine&nbsp;1.
At machine&nbsp;1, we should begin with job&nbsp;0.
Before job&nbsp;0 can be put on machine&nbsp;1, it must go through machine&nbsp;0.
So job&nbsp;1 cannot go to machine&nbsp;0 until it has passed through machine&nbsp;1, but in order to be executed on machine&nbsp;1, job&nbsp;0 needs to be finished there first.
Job&nbsp;0 cannot begin on machine&nbsp;1 until it has been passed through machine&nbsp;0, but it cannot be executed there, because job&nbsp;1 needs to be finished there first.
A cyclic blockage has appeared: no job can be executed on any machine if we follow this schedule.
This is called a deadlock.
No jobs overlap in the schedule.
All operations are assigned to proper machines and receive the right processing times.
Still, the schedule is infeasible, because it cannot be executed or written down without breaking the precedence constraint.

Hence, there are only three out of four possible Gantt charts that work for this problem instance.
For a problem instance where the jobs need to pass through all machines in the same sequence, however, all possible Gantt charts will work, as also illustrated in the second column of [@fig:jssp_feasible_gantt].
The number of actually feasible Gantt charts in&nbsp;$\solutionSpace$ thus can be different for different problem instances.

This is very annoying.
The potential existence of infeasible solutions means that we cannot just pick a good element from&nbsp;$\solutionSpace$ (according to whatever *good* means), we also must be sure that it is actually *feasible*.
An optimization algorithm which might sometimes return infeasible solutions will not be acceptable. 


#### Summary 

|name|$\jsspJobs$|$\jsspMachines$|$\min(\#\text{feasible})$|$\left|\solutionSpace\right|$|
|:--|--:|--:|--:|--:|
|[@fig:jssp_feasible_gantt]|2|2|3|4|
||2|3|4|8|
||2|4|5|16|
||2|5|6|32|
||3|2|22|36|
||3|3|63|216|
||3|4|147|1'296|
||3|5|317|7'776|
||4|2|244|576|
||4|3|1'630|13'824|
||4|4|7'451|331'776|
|`demo`|4|5||7'962'624|
||5|2|4'548|14'400|
||5|3|91'461|1'728'000|
||5|4||207'360'000|
||5|5||24'883'200'000|
|`ft06`|6|6||$\approx$&nbsp;1.393*10^17^|
|`la09`|15|5||$\approx$&nbsp;3.824*10^60^|
|`abz8`|20|15||$\approx$&nbsp;6.193*10^275^|
|`yn2`|20|20||$\approx$&nbsp;5.278*10^367^|
|`swv18`|50|10||$\approx$&nbsp;6.772*10^644^|
|`ta54`|50|15||$\approx$&nbsp;1.762*10^967^|
|`dmu40`|50|20||$\approx$&nbsp;4.587*10^1'289^|
|`ta79`|100|20||$\approx$&nbsp;2.512*10^3'159^|

: The size&nbsp;$\left|\solutionSpace\right|$ of the solution space&nbsp;$\solutionSpace$ (without schedules that stall uselessly) for selected values of the number&nbsp;$\jsspJobs$ of jobs and the number&nbsp;$\jsspMachines$ of machines of an JSSP instance&nbsp;$\instance$ (later compare also with [@fig:function_growth]). {#tbl:jsspSolutionSpaceTable}

We illustrate some examples for the number&nbsp;$\left|\solutionSpace\right|$ of possible schedules which do not waste time uselessly for different values of&nbsp;$\jsspJobs$ and&nbsp;$\jsspMachines$ in [@tbl:jsspSolutionSpaceTable].
Since we use instances for testing our JSSP algorithms, we have added their settings as well and listed them in column "name".
Of course, there are infinitely many JSSP instances for a given setting of&nbsp;$\jsspJobs$ and&nbsp;$\jsspMachines$ and our instances always only mark single examples for them.

We find that even small problems with $\jsspMachines=5$ machines and $\jsspJobs=5$ jobs already have billions of possible solutions.
The eight more realistic problem instances which we will try to solve here already have more solutions that what we could ever enumerate, list, or store with any conceivable hardware or computer.
For the smallest of them, `ft06`, which has six jobs and six machines, we could theoretically construct 139'314'069'504'000'000 $\approx$&nbsp;1.393\*10^17^ possible Gantt charts (some of which may not be feasible).
The biggest of them, `ta79`, has 100&nbsp;jobs and 20&nbsp;machines, which means that the number of theoretically possible solutions is about 2.512\*10^3'159^, a number that would easily fill a whole single sheet of paper if written down&hellip;
From this, it becomes immediately clear:
We cannot simply test all possible solutions and pick the best one.
We will need some more sophisticated algorithms to solve these problems.
This is what we will discuss in the following, the topic of this book.

Different JSSP instances can have different numbers&nbsp;$\#\text{feasible}$ of possible *feasible* Gantt charts, even if they have the same numbers of machines and jobs.
For a given setting of&nbsp;$\jsspMachines$ and&nbsp;$\jsspJobs$, we are interested in the minimum&nbsp;$\min(\#\text{feasible})$ of this number, i.e., the *smallest value* that&nbsp;$\#\text{feasible}$ can take on over all possible instances with $\jsspJobs$&nbsp;jobs and $\jsspMachines$&nbsp;machines.
I don't know how to compute this number and we only want to see out of academic curiosity.
So, I just enumerated the instances and Gantt charts for small settings of $\jsspMachines$ and $\jsspJobs$.  
In [@tbl:jsspSolutionSpaceTable], I then provide the smallest results I got.
Interestingly, we find that most of the possible Gantt charts for a problem instance might be infeasible, as&nbsp;$\min(\#\text{feasible})$ can be much smaller than&nbsp;$\left|\solutionSpace\right|$.
