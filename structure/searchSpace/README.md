## The Search Space {#sec:searchSpace}

The solution space&nbsp;$\solutionSpace$ is the data structure that "makes sense" from the perspective of the user, the decision maker, who will be supplied with one instance of this structure (a candidate solution) at the end of the optimization procedure.
But&nbsp;$\solutionSpace$ not necessarily is the space that is most suitable for searching inside.

We have already seen that there are several constraints that apply to the Gantt charts.
For every problem instance, different solutions may be feasible.
Besides the constraints, the space of Gantt charts also looks kind of unordered, unstructured, and messy.
Actually, many data structures that represent real-world objects with their features, be it Gantt charts, construction plans of airplane wings, or plans for electronic circuits are specialized and do not lend them themselves to be directly processed by general algorithms.
It would be nice to have a compact, clear, and easy-to-understand representation of the candidate solutions.


### Definitions

\definition{def}{searchSpace}{The *search space*&nbsp;$\searchSpace$ is a representation of the solution space&nbsp;$\solutionSpace$ suitable for exploration by an algorithm.}

\definition{def}{searchSpacePoint}{The elements&nbsp;$\sespel\in\searchSpace$ of the search space $\searchSpace$ are called *points* in the search space.}

\definition{def}{decoding}{The *decoding function*&nbsp;$\decode:\searchSpace\mapsto\solutionSpace$ is a left-total relation which maps each point&nbsp;$\sespel\in\searchSpace$ of the search space&nbsp;$\searchSpace$ to one candidate solutions&nbsp;$\solspel\in\solutionSpace$ in the solution space&nbsp;$\solutionSpace$.}

\definition{def}{encoding}{The search space&nbsp;$\searchSpace$ and decoding function&nbsp;$\decode$ together are called the *encoding* or the *representation*.}

The solution space&nbsp;$\solutionSpace$ is what the user cares about.
The optimization algorithm *only* works on the search space&nbsp;$\searchSpace$.
It does not need to know or care about what the candidate solutions are.
The candidate solutions can be complex structures, such as the shape of the nose of a fast train&nbsp;[@IMNFM1997ENSFRTSB; @KIF2011OOTNSFRMPWRFTE].
It is hard to imagine how to search inside the space of all possible such shapes in a targeted way.
However, maybe we could encode the surfaces of the train noses as vectors of real numbers.
The search space could then just be an $n$-dimensional real vector space.
This changes everything.
We know and understand these vector spaces since high school.
We have all kinds of tools available to search in it in an ordered fashion, ranging from distance metrics to vector mathematics.
Suddenly, the problem becomes easier to approach algorithmically.
Moreover, since real vector spaces are very common, there already exists a wide variety of algorithms that can perform optimization over them.
A good encoding, i.e., a suitable search space&nbsp;$\searchSpace$ and mapping&nbsp;$\decode:\searchSpace\mapsto\solutionSpace$ therefore can make our life much easier. 

For applying an optimization algorithm, we therefore usually choose a data structure&nbsp;$\searchSpace$ which we can understand intuitively.
Ideally, it should be possible to define concepts such as distances, similarity, or neighborhoods on this data structure.
Spaces that are especially suitable for searching in include, for example:

1. subsets of $n$-dimensional real vectors, i.e., $\realNumbers^n$,
2. the set&nbsp;$\mathSpace{P}(n)$ of permutations of&nbsp;$n$ objects, and
3. a number of&nbsp;$n$ yes-no decisions, which can be represented as bit strings of length&nbsp;$n$, spanning the space&nbsp;$\{0,1\}^n$.

For such spaces, we can relatively easily define good search methods and can rely on a large amount of existing research work and literature.
If we are lucky, then our solution space&nbsp;$\solutionSpace$ is already "similar" to one of these well-known and well-researched data structures.
Then, we can set&nbsp;$\searchSpace=\solutionSpace$ and use the identity mapping&nbsp;$\decode(\sespel)=\sespel\;\forall \sespel\in\searchSpace$ as decoding function.
In other cases, we will often prefer to map&nbsp;$\solutionSpace$ to something similar to these spaces and define&nbsp;$\decode$ accordingly.  

The mapping&nbsp;$\decode$ does not need to be injective, as it may map two points&nbsp;$\sespel_1$ and&nbsp;$\sespel_2$ to the same candidate solution even though they are different ($\sespel_1\neq \sespel_2$).
Then, there exists some redundancy in the search space.
We would normally like to avoid redundancy, as it tends to slow down the optimization process&nbsp;[@KW2002OTUOREIMBES].
Being injective is therefore a good feature for&nbsp;$\decode$.

The mapping&nbsp;$\decode$ also does not necessarily need to be surjective, i.e., there can be candidate solutions&nbsp;$\solspel\in\solutionSpace$ for which no&nbsp;$\sespel\in\searchSpace$ with $\decode(\sespel)=\solspel$ exists.
However, such solutions then can never be discovered.
If the optimal solution would be among those unreachable ones, then, well, it could not be found by the optimization process.
Being surjective is therefore a good feature for&nbsp;$\decode$.

Finally, and as a side note:
Technically speaking, $\decode$ does not even necessarily be a function.
It could be a randomized procedure, meaning that two invocations could lead to different results.


### A Programmer's Perspective

In [@lst:Space], we already have defined a simple API to provide common operations for (solution) spaces.
We can reuse this very same API for search spaces too.
Additionally, we need a function that can convert from points in the search space to candidate solutions. 


\git.code{mp}{Encoding}{An base class for encodings.}{moptipy/api/encoding.py}{}{book}{doc}


The class given in [@lst:Encoding] provides the blueprint for a function `map` which translates one point&nbsp;`x` in the search space to a candidate solution instance&nbsp;`y` of the solution space.
This `map` function corresponds to the general definition $\decode:\searchSpace\mapsto\solutionSpace$ of the encoding.
An implementation of `map` will overwrite whatever contents were stored in object&nbsp;`y` in the process, i.e., we assume the objects&nbsp;`y` can be modified.


### Example: Job Shop Scheduling {#sec:jsspSearchSpace}

In our JSSP example problem, the candidate solutions are Gantt charts.
We developed the class `Gantt` given in [@lst:jssp_gantt] to represent their data.
This data can easily be interpreted and visualized by the user.
Yet, it is not that clear how we can efficiently create such solutions, especially feasible ones, let alone how to *search* in the space of Gantt charts.^[Of course, there are many algorithms that can do that and we could discover one if we would seriously think about it, but here we take the educational route where we investigate the full scenario with&nbsp;$\searchSpace\neq\solutionSpace$.]
What we would like to have is a *search space*&nbsp;$\searchSpace$, which can represent the possible candidate solutions of the problem in a more machine-tangible, algorithm-friendly way.
The JSSP is a very well-known problem.
Comprehensive overviews about different such search spaces for the JSSP can be found in [@CGT1996ATSOJSSPUGAIR;@W2013GAFSSPAS;@A2010RIGAFTJSPACS;@YN1997GAFJSSP].
We here will develop only one single idea which I find particularly appealing.


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

\rel.figure{jssp_encoding}{Illustration of the first five and the second-to-last steps of the decoding of an example point in the search space to a candidate solution.}{jssp_encoding.svgz}{width=97.5%}

This decoding procedure can best be described by an example.
In the demo instance, we have&nbsp;$\jsspMachines=5$ machines and&nbsp;$\jsspJobs=4$ jobs.
Each job has&nbsp;$\jsspMachines=5$ operations that must be distributed to the machines.
We use a string of length&nbsp;$\jsspMachines*\jsspJobs=20$ denoting the priority of the operations.
We *know* the order of the operations per job as part of the problem instance data&nbsp;$\instance$.
We therefore do not need to encode it.
This means that we just include each job's id&nbsp;$\jsspMachines=5$ times in the string.
This was the original idea:
The encoding represents the order in which we assign the $\jsspJobs$&nbsp;jobs, and each job must be picked $\jsspMachines$&nbsp;times.
Our search space is thus somehow similar to the set&nbsp;$\mathSpace{P}(\jsspJobs*\jsspMachines)$ of permutations of&nbsp;$\jsspJobs*\jsspMachines$ objects mentioned earlier, but instead of permutations, we have *permutations with repetitions*.

A point&nbsp;$\sespel\in\searchSpace$ in the search space&nbsp;$\searchSpace$ for the `demo` JSSP instance would thus be an integer string of length&nbsp;20.
As example, we choose $\sespel=(0, 2, 3, 2, 2, 3, 1, 1, 0, 3, 1, 3, 2, 1, 3, 2, 0, 1, 0, 0)$.
Let us now exercise the decoding procedure&nbsp;$\decode(\sespel)$.
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

We continue this iterative process.
The last row of [@fig:jssp_encoding] illustrates the second-to-last decoding step.
It places the second-to-last operation of job&nbsp;0 onto machine&nbsp;3.
The previous (i.e., third) operation of the job was on machine&nbsp;2 and completed there after 180&nbsp;time units.
Machine&nbsp;3 is idle at that time, so operation&nbsp;4 of job&nbsp;1 will occupy it from time index&nbsp;180 to&nbsp;220.
This only leaves the last operation of job&nbsp;1 to be assigned, which will take&nbsp;10 time units on machine&nbsp;4.
It can start there directly at time index&nbsp;220 and will finish on time index&nbsp;230 (illustrated in dark gray in the figure).

The Gantt chart then is complete.
Whenever we assign a operation&nbsp;$\jsspJobIndex>0$ of any given job to a machine, then we already had assigned all operations at smaller indices first.
No deadlock can occur and&nbsp;$\solspel$ must therefore be feasible.

\git.code{mp}{jssp_encoding}{An excerpt of the implementation of the operation-based encoding for the JSSP.}{moptipy/examples/jssp/ob_encoding.py}{}{book}{comments,doc}

In [@lst:jssp_encoding], we illustrate how such an encoding can be implemented.
It basically is a function translating an [numpy integer array](https://numpy.org/doc/stable/user/basics.types.html) to a `Gantt` chart.
We put the algorithm into a function `decode`, so that we can mark it for compilation with [numba](https://numba.pydata.org/) to improve the performance, utilizing the performance tips discussed in [@sec:pythonNumba; @sec:pythonCallingMethodsAndFunctions].

\git.code{mp}{PermutationsWithRepetitions}{Excerpt of the implementation of the `Space` API [@lst:Space] for permutations with (or without) repetitions.}{moptipy/spaces/permutations.py}{}{book}{doc,comments}

In [@lst:PermutationsWithRepetitions], we just provide a very small excerpt of an implementation of the `Space` API for permutations of numbers stored in [numpy arrays](https://numpy.org/doc/stable/reference/generated/numpy.array.html).
This class is quite general:
We provide a `blueprint` string of the numbers that we want to arrange in the permutations.
This could be a true permutation, e.g., $[1, 2, 3]$, or a permutation with repetitions, such as $[1, 1, 2, 2, 3, 3]$.
The `create` method of the `Space` implementation will always return a copy of that blueprint array.
We omit the conversion to and from text strings, as it can be implemented similarly as in [@lst:jssp_gantt_space].
Validation can simply check whether each job ID occurs exactly as needed, i.e., $\jsspMachines$&nbsp;times in our case, and is thus also not printed.
The static method `with_repetitions` instantiates the space for $\jsspMachines$&nbsp;repetitions of the permutation&nbsp;$0..\jsspJobs$.


#### Advantages of this very simple Encoding

This is a natural way to represent Gantt charts with a much simpler data structure.
As a result, it has been discovered by several researchers independently, the earliest being Gen et&nbsp;al.&nbsp;[@GTK1994SJSSPBGA], Bierwirth&nbsp;[@B1995AGPATJSSWGA; @BMK1996OPRFSP], and Shi et&nbsp;al.&nbsp;[@SIS1997NESFSJSPBGA], all in the 1990s.

But what do we gain by using this encoding?
First, well, we now have a very simple data structure&nbsp;$\searchSpace$ to represent our candidate solutions.
Second, we also have very simple rules for validating a point&nbsp;$\sespel$ in the search space:
If it contains the numbers&nbsp;$\intRange{0}{(\jsspJobs-1)}$ each exactly&nbsp;$\jsspMachines$ times, it represents a feasible candidate solution.

Third, the candidate solution corresponding to a valid point from the search space will always be *feasible*&nbsp;[@B1995AGPATJSSWGA].
The mapping&nbsp;$\decode$ will ensure that the order of the operations per job is always observed.
We have solved the issue of deadlocks mentioned in [@sec:solutionSpace:feasibility].
We know from [@tbl:jsspSolutionSpaceTable], that the vast majority of the possible Gantt charts for a given problem might actually be infeasible &ndash; and now we do no longer need to worry about that. 
Our mapping&nbsp;$\decode$ also obeys the more trivial constraints, such as that each machine will process at most one job at a time and that all operations are eventually processed.

Finally, we also could modify our decoding function&nbsp;$\decode$ to adapt to more complicated and constraint versions of the JSSP if need be:
For example, imagine that it would take a job- and machine-dependent time requirement for carrying a job from one machine to another.
We could facilitate this by changing&nbsp;$\decode$ so that it adds this time to the starting time of the job.
If there was a job-dependent setup time for each machine&nbsp;[@ANCK2008ASOSPWSTOC], which could be different if job&nbsp;1 follows job&nbsp;0 instead of job&nbsp;2, then this could be facilitated easily as well.
If our operations would be assigned to "machine types" instead of "machines" and there could be more than one machine per machine type, then the representation mapping could assign the operations to the next machine of their type which becomes idle.
Our representation also trivially covers the situation where each job may have more than&nbsp;$\jsspMachines$ operations, i.e., where a job may need to cycle back and pass one machine twice.
It is also suitable for simpler scenarios, such as the Flow Shop Problem, where all jobs pass through the machines in the same, pre-determined order&nbsp;[@T199BFBSP; @GJS1976TCOFAJS; @W2013GAFSSPAS].

Many such different problem flavors can now be reduced to investigating the same space&nbsp;$\searchSpace$ using the same optimization algorithms, just with different decoding function&nbsp;$\decode$ and/or objective functions&nbsp;$\objf$.
Additionally, it becomes  easy to indirectly create and modify candidate solutions by sampling points from the search space and moving to similar points, as we will see in the following chapters.


#### Size of the Search Space {#sec:size_of_jssp_search_space}

It is relatively easy to compute the size&nbsp;$\left|\searchSpace\right|$ of our proposed search space&nbsp;$\searchSpace$&nbsp;[@SIS1997NESFSJSPBGA].
We do not need to make any assumptions regarding "no useless waiting time", as in [@sec:solutionSpace:size], since this is not possible by default.
Each element&nbsp;$\sespel\in\searchSpace$ is a permutation of a multiset where each of the&nbsp;$\jsspJobs$ elements occurs exactly&nbsp;$\jsspMachines$ times.
This means that the size of the search space can be computed as given in [@eq:jssp_search_space_size].

$$ \left|\searchSpace\right| = \frac{\left(\jsspMachines*\jsspJobs\right)!}{ \left(\jsspMachines!\right)^{\jsspJobs} } $$ {#eq:jssp_search_space_size}

To better understand this equation, imagine the space of all permutations of the sequence $(1, 2, 3, 4)$.
Clearly there are $4!=2*3*4=24$ such permutations.
Now let us imagine that one number, say $3$, appears twice, e.g., we want the permutations of $(1, 2, 3, 3, 4)$.
There are five elements now, so there are $5!=120$ possible ways to arrange them.
However, the number $3$ appears twice and it does not matter which of the $3$s appears first, so we get $5!/2=60$ possible unique permutations.
If we add another&nbsp;$3$, i.e., $3$ would appear three times and we have $(1, 2, 3, 3, 3, 4)$, then there would be $6!/3!=720/6=120$ possible arrangements.
If we now add another two&nbsp;$4$s, we get $(1, 2, 3, 3, 3, 4, 4, 4)$.
This sequence can be arranged in $8!/(3!*3!)=40320/36=120$ possible ways.
If each one of $\jsspJobs$ different numbers appears $\jsspMachines$ times, we hence have $(\jsspJobs*\jsspMachines)/(\jsspMachines)^{\jsspJobs}$ different possible permutations &ndash; as shown in [@eq:jssp_search_space_size]. 

|name|$\jsspJobs$|$\jsspMachines$|$\left|\solutionSpace\right|$|$\left|\searchSpace\right|$|
|:--|--:|--:|--:|--:|
||3|2|36|90|
||3|3|216|1'680|
||3|4|1'296|34'650|
||3|5|7'776|756'756|
||4|2|576|2'520|
||4|3|13'824|369'600|
||4|4|331'776|63'063'000|
|`demo`|4|5|7'962'624|11'732'745'024|
||5|2|14'400|113'400|
||5|3|1'728'000|168'168'000|
||5|4|207'360'000|305'540'235'000|
||5|5|24'883'200'000|$\approx$&nbsp;6.234*10^14^|
|`orb06`|10|10|$\approx$&nbsp;3.959*10^65^|$\approx$&nbsp;2.357*10^92^|
|`la38`|15|15|$\approx$&nbsp;5.591*10^181^|$\approx$&nbsp;2.252*10^251^|
|`abz8`|20|15|$\approx$&nbsp;6.193*10^275^|$\approx$&nbsp;1.432*10^372^|
|`yn4`|20|20|$\approx$&nbsp;5.278*10^367^|$\approx$&nbsp;1.213*10^501^|
|`swv14`|50|10|$\approx$&nbsp;6.772*10^644^|$\approx$&nbsp;1.254*10^806^|
|`dmu72`|50|15|$\approx$&nbsp;1.762*10^967^|$\approx$&nbsp;3.862*10^1'226^|
|`dmu67`|40|20|$\approx$&nbsp;1.710*10^958^|$\approx$&nbsp;2.768*10^1'241^|
|`ta70`|50|20|$\approx$&nbsp;4.587*10^1'289^|$\approx$&nbsp;1.988*10^1'648^|

: The sizes&nbsp;$\left|\searchSpace\right|$ and&nbsp;$\left|\solutionSpace\right|$ of the search and solution spaces for selected values of the number&nbsp;$\jsspJobs$ of jobs and the number&nbsp;$\jsspMachines$ of machines of an JSSP instance&nbsp;$\instance$. (compare with [@fig:function_growth] and with the size&nbsp;$\left|\solutionSpace\right|$ of the solution space) {#tbl:jsspSearchSpaceTable}

We give some example values for this search space size&nbsp;$\left|\searchSpace\right|$ in [@tbl:jsspSearchSpaceTable].
From the table, we can immediately see that the number of points in the search space, too, grows very quickly with both the number of jobs&nbsp;$\jsspJobs$ and the number of machines&nbsp;$\jsspMachines$ of an JSSP instance&nbsp;$\instance$.
If we compare the ordering of our example JSSP instances by search space size with the ordering by solution space, we find that there only is one disagreement:
`dmu67` has the larger search space&nbsp;$\searchSpace$ but a smaller solution space&nbsp;$\solutionSpace$ compared to `dmu72`.
Apart from this, larger solution spaces tend to correspond to larger search spaces as well. 

 For our `demo` JSSP instance with&nbsp;$\jsspJobs=4$ jobs and&nbsp;$\jsspMachines=5$ machines, we already have about 12&nbsp;billion different points in the search space that represent 7&nbsp;million possible non-wasteful candidate solutions.

We now find the drawback of our encoding:
There is some redundancy in our mapping.
$\decode$&nbsp; is not injective.
Some elements of the search space&nbsp;$\searchSpace$ will map to the same element in the solution space&nbsp;$\solutionSpace$. 
For example, we could arbitrarily swap the first three numbers in the example string in [@fig:jssp_encoding] and would obtain the same Gantt chart, because jobs&nbsp;0, 2, and&nbsp;3 start at different machines.

As said before, we should avoid redundancy in the search space.
However, here we will stick with our proposed mapping because it is very simple, it solves the problem of feasibility of candidate solutions, and it allows us to relatively easily introduce and discuss many different approaches, algorithms, and sub-algorithm
