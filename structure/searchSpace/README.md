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
