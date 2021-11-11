## The Search Space and Encoding {#sec:searchSpace}

The solution space&nbsp;$\solutionSpace$ is the data structure that "makes sense" from the perspective of the user, the decision maker, who will be supplied with one instance of this structure (a candidate solution) at the end of the optimization procedure.
But&nbsp;$\solutionSpace$ not necessarily is the space that is most suitable for searching inside.

We have already seen that there are several constraints that apply to the Gantt charts.
For every problem instance, different solutions may be feasible.
Besides the constraints, the space of Gantt charts also looks kind of unordered, unstructured, and messy.
It would be nice to have a compact, clear, and easy-to-understand representation of the candidate solutions.


### Definitions

\definition{def}{searchSpace}{The *search space*&nbsp;$\searchSpace$ is a representation of the solution space&nbsp;$\solutionSpace$ suitable for exploration by an algorithm.}

\definition{def}{searchSpacePoint}{The elements&nbsp;$\sespel\in\searchSpace$ of the search space $\searchSpace$ are called *points* in the search space.}

\definition{def}{representationMapping}{The *encoding*&nbsp;$\encoding:\searchSpace\mapsto\solutionSpace$ is a left-total relation which maps each point&nbsp;$\sespel\in\searchSpace$ of the search space&nbsp;$\searchSpace$ to one candidate solutions&nbsp;$\solspel\in\solutionSpace$ in the solution space&nbsp;$\solutionSpace$.}

The solution space&nbsp;$\solutionSpace$ is what the user cares about.
The optimization algorithm *only* works on the search space&nbsp;$\searchSpace$.
It does not need to know or care about what the candidate solutions are.
The candidate solutions can be complex structures, such as the shape of the nose of a fast train&nbsp;[@IMNFM1997ENSFRTSB; @KIF2011OOTNSFRMPWRFTE].
It is hard to imagine how to search such shapes in a targeted way.
However, maybe we could encode the surfaces of the train noses as vectors of real numbers.
The search space could then just be an $n$-dimensional real vector space.
This changes everything.
We know and understand these vector spaces since high school.
We have all kinds of tools available, ranging from distance metrics to vector mathematics, to search in it in an ordered fashion.
Suddenly, the problem becomes easier to approach algorithmically.
Moreover, since real vector spaces are very common, there already exists a wide variety of algorithms that can perform optimization over them.
A good search space and encoding therefore can make our life much easier. 

For applying an optimization algorithm, we therefore usually choose a data structure&nbsp;$\searchSpace$ which we can understand intuitively.
Ideally, it should be possible to define concepts such as distances, similarity, or neighborhoods on this data structure.
Spaces that are especially suitable for searching in include, for example:

1. subsets of $n$-dimensional real vectors, i.e., $\realNumbers^n$,
2. the set&nbsp;$\mathSpace{P}(n)$ of sequences/permutations of&nbsp;$n$ objects, and
3. a number of&nbsp;$n$ yes-no decisions, which can be represented as bit strings of length&nbsp;$n$ and spans the space&nbsp;$\{0,1\}^n$.

For such spaces, we can relatively easily define good search methods and can rely on a large amount of existing research work and literature.
If we are lucky, then our solution space&nbsp;$\solutionSpace$ is already "similar" to one of these well-known and well-researched data structures.
Then, we can set&nbsp;$\searchSpace=\solutionSpace$ and use the identity mapping&nbsp;$\encoding(\sespel)=\sespel\;\forall \sespel\in\searchSpace$ as encoding.
In other cases, we will often prefer to map&nbsp;$\solutionSpace$ to something similar to these spaces and define&nbsp;$\encoding$ accordingly.  

The mapping&nbsp;$\encoding$ does not need to be injective, as it may map two points&nbsp;$\sespel_1$ and&nbsp;$\sespel_2$ to the same candidate solution even though they are different ($\sespel_1\neq \sespel_2$).
Then, there exists some redundancy in the search space.
We would normally like to avoid redundancy, as it tends to slow down the optimization process&nbsp;[@KW2002OTUOREIMBES].
Being injective is therefore a good feature for&nbsp;$\encoding$.

The mapping&nbsp;$\encoding$ also does not necessarily need to be surjective, i.e., there can be candidate solutions&nbsp;$\solspel\in\solutionSpace$ for which no&nbsp;$\sespel\in\searchSpace$ with $\encoding(\sespel)=\solspel$ exists.
However, such solutions then can never be discovered.
If the optimal solution would be among those unreachable ones, then, well, it could not be found by the optimization process.
Being surjective is therefore a good feature for&nbsp;$\encoding$.

\git.code{mp}{Encoding}{An abstract base class for encodings.}{moptipy/api/encoding.py}{}{book}{doc,hints}

The abstract class given in [@lst:Encoding] provides a function `map` which maps one point&nbsp;`x` in the search space to a candidate solution instance&nbsp;`y` of the solution space.
This class corresponds to the general definition $\encoding:\searchSpace\mapsto\solutionSpace$ of the encoding.
An implementation of `map` will overwrite whatever contents were stored in object&nbsp;`y` in the process, i.e., we assume the objects&nbsp;`y` can be modified.


### Example: Job Shop Scheduling {#sec:jsspSearchSpace}

In our JSSP example problem, the candidate solutions are Gantt charts.
We developed the class `Gantt` given in [@lst:jssp_gantt] to represent their data.
This data can easily be interpreted by and visualized the user.
Yet, it is not that clear how we can efficiently create such solutions, especially feasible ones, let alone how to *search* in the space of Gantt charts.^[Of course, there are many algorithms that can do that and we could discover one if we would seriously think about it, but here we take the educational route where we investigate the full scenario with&nbsp;$\searchSpace\neq\solutionSpace$.]
What we would like to have is a *search space*&nbsp;$\searchSpace$, which can represent the possible candidate solutions of the problem in a more machine-tangible, algorithm-friendly way.
The JSSP is a very well-known problem.
Comprehensive overviews about different such search spaces for the JSSP can be found in [@CGT1996ATSOJSSPUGAIR;@W2013GAFSSPAS;@A2010RIGAFTJSPACS;@YN1997GAFJSSP], we here develop only one single idea which I find particularly appealing.


#### Idea: 1-dimensional Encoding

Imagine you would like to construct a Gantt chart as candidate solution for a given JSSP instance.
How would you do that?
Well, we know that each of the $\jsspJobs$&nbsp;jobs has $\jsspMachines$&nbsp;operations, one for each machine.
We could simply begin by choosing one job and placing its first operation on the machine to which it belongs, i.e., write it into the Gantt chart.
Then we again pick a job, take the first not-yet-scheduled operation of this job, and "add" it to the end of the row of its corresponding machine in the Gantt chart.
Of course, we cannot pick a job whose operations all have already be assigned.
We can continue doing this until all operations of all jobs are assigned &ndash; and we will get a valid solution.

This solution is defined by the order in which we chose the jobs.
Such an order can be described as a simple, linear string of job IDs, i.e., of integer numbers.
If we process such a string from the beginning to the end and step-by-step assign the jobs, we get a feasible Gantt chart as result.
It is not possible to produce a deadlock (see [@sec:solutionSpace:feasibility]), because we will only allocate an operation to a machine after having placed all operations that come before it in the same job.

This encoding can best be described by an example.
In the demo instance, we have&nbsp;$\jsspMachines=5$ machines and&nbsp;$\jsspJobs=4$ jobs.
Each job has&nbsp;$\jsspMachines=5$ operations that must be distributed to the machines.
We use a string of length&nbsp;$\jsspMachines*\jsspJobs=20$ denoting the priority of the operations.
We *know* the order of the operations per job as part of the problem instance data&nbsp;$\instance$.
We therefore do not need to encode it.
This means that we just include each job's id&nbsp;$\jsspMachines=5$ times in the string.
This was the original idea: The encoding represents the order in which we assign the $\jsspJobs$&nbsp;jobs, and each job must be picked $\jsspMachines$&nbsp;times.
Our search space is thus somehow similar to the set&nbsp;$\mathSpace{P}(\jsspJobs*\jsspMachines)$ of permutations of&nbsp;$\jsspJobs*\jsspMachines$ objects mentioned earlier, but instead of permutations, we have *permutations with repetitions*.

\rel.figure{jssp_encoding}{Illustration of the first five and the second-to-last steps of the encoding of an example point in the search space to a candidate solution.}{jssp_encoding.svgz}{width=97.5%}

A point&nbsp;$\sespel\in\searchSpace$ in the search space&nbsp;$\searchSpace$ for the `demo` JSSP instance would thus be an integer string of length&nbsp;20.
As example, we choose $\sespel=(0, 2, 3, 2, 2, 3, 1, 1, 0, 3, 1, 3, 2, 1, 3, 2, 0, 1, 0, 0)$.
Let us now exercise the encoding&nbsp;$\encoding(\sespel)$.
In [@fig:jssp_encoding], we sketch several of its steps.
For each step, we show the instance data&nbsp;$\instance$ on the left, the point&nbsp;$\sespel$ in the search space in the middle, and the current state of the Gantt chart&nbsp;$\solspel$ on the right hand side.

The decoding of the string&nbsp;$\sespel$ starts with an empty Gantt chart.
This string is interpreted from left to right, as illustrated in the figure.
The first value is&nbsp;0, which means that, in the first step, job&nbsp;0 is assigned to a machine.
From the instance data, we know that job&nbsp;0 first must be executed for 10&nbsp;time units on machine&nbsp;0.
The job is thus inserted on machine&nbsp;0 in the chart.
Since machine&nbsp;0 is initially idle, it can be placed at time index&nbsp;0.
We also know that this operation can definitely be executed, i.e., won't cause a deadlock, because it is the first operation of the job.
Once we have placed it in the chart, we cross it out to mark it as done.
This is done in the first line in our figure.

The next value in the string is&nbsp;2, meaning that we now need to insert an operation from job&nbsp;2.
No operation from this job was processed yet, so we pick its first operation.
From the instance data, we see that it should go to machine&nbsp;2 for 30&nbsp;time units.
In our current Gantt chart, no job has yet been assigned to machine&nbsp;2, so we can place it there at time index&nbsp;0.
This is done in the second line of the figure.

We then encounter the value&nbsp;3 in the string for the first time.
Job&nbsp;3 first goes to machine&nbsp;4 for 50&nbsp;time units.
Machine&nbsp;4 is still unused, so we can place it there directly and mark it as done, as shown in line&nbsp;3 of our figure.

Next we encounter job&nbsp;2 again, i.e., for the second time.
We have already marked its first operation as done, as we now need to allocate its second operation.
It should go to machine&nbsp;1 for 20&nbsp;time units.
While machine&nbsp;1 has no job assigned to it yet, we cannot place the operation at time index&nbsp;0.
We first need to wait for the first operation of job&nbsp;2 to complete, which happens at time index&nbsp;30.
Hence, we can start the operation at that time.

In the fifth row of [@fig:jssp_encoding], we again find job&nbsp;2.
We need to assign its third operation, which goes to machine&nbsp;4 and will need 12&nbsp;time units there.
It can only start after the second operation of the job is completed, which happens after $30+20=50$&nbsp;time units.
Also, machine&nbsp;4 is used by job&nbsp;3, whose first operation will be completed there also after 50&nbsp;time units.
Therefore, the third operation of job&nbsp;2 can begin there at time index&nbsp;50.

We then again encounter job&nbsp;3 in&nbsp;$\sespel$, which means we need to assign its second operation.
This operation goes to machine&nbsp;3 and can start at time index&nbsp;50, after the first operation of the job has been completed.
Then we will encounter job&nbsp;1 for the first time and allocate its first operation to machine&nbsp;1 for 20&nbsp;time units.
It can start after the second operation of job&nbsp;2 which is already assigned to that machine completes, i.e., at time index&nbsp;50.^[The reader will notice: Actually, we could let it start at time index&nbsp;0, which would not interfere with the operation of job&nbsp;2. However, this would make the mapping more complicated and we will stick to the easier approach here.]
Directly afterwards, job&nbsp;1 needs to be assigned again and its second operation will go to machine&nbsp;0.
It can start at time index&nbsp;$50+20=70$, namely after its first operation is completed.

We will continue this process.
The last row of [@fig:jssp_encoding] illustrates the second-to-last decoding step.
It places the second-to-last operation of job&nbsp;0 onto machine&nbsp;3.
The previous (i.e., third) operation of the job was on machine&nbsp;2 and completed there after 180&nbsp;time units.
Machine&nbsp;3 is idle at that time, so operation&nbsp;4 of job&nbsp;1 will occupy it from time index&nbsp;180 to&nbsp;220.
This only leaves the last operation of job&nbsp;1 to be assigned, which will take&nbsp;10 time units on machine&nbsp;4.
It can start there directly at time index&nbsp;220 and will finish on time index&nbsp;230 (illustrated in dark gray in the figure).
The Gantt chart then is complete.
