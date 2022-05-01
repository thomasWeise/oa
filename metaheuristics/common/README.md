## Common Characteristics {#sec:metaheuristicsCommon}

Before we delve into our first algorithms, let us first take a look on some things that all metaheuristics have in common.

### Anytime Algorithms {#sec:anytimeAlgorithm}

\definition{def}{anytimeAlgorithm}{An *anytime algorithm* is an algorithm which can provide an approximate result during almost any time of its execution.}

Basically, an anytime algorithm is an algorithm that I can stop at (almost) any time and still obtain a solution to my problem&nbsp;[@BD1989STDPP].
All metaheuristics &ndash; and many other optimization and machine learning methods &ndash; are anytime algorithms.
The idea behind anytime algorithms is that they start with (potentially bad) guess about what a good solution would be.
During their course, they try to improve their approximation quality.
They try to produce better and better candidate solutions.
At any point in time, we can extract the current best guess about the optimum and stop the optimization process if we want to.
This fits to the optimization situation that we have discussed in [@sec:terminationCriterion]:
We often cannot find out whether the best solution we currently have is the globally optimal solution for the given problem instance or not, so we simply continue trying to improve upon it until a *termination criterion* tells us to quit, e.g., until the time is up.


### Return the Best-So-Far Candidate Solution {#sec:rememberBest}

This common characteristic is actually quite simple, yet often ignored and misunderstood by novices to the subject:
Regardless what the optimization algorithm does, it will never *NEVER* forget the best-so-far candidate solution.
Often, this is not explicitly written in the formal definition of the algorithms, but there *always* exists a special variable somewhere storing that solution.
This variable is updated each time a better solution is found.
Its value is returned when the algorithm stops.

Some algorithms are constructed such that they work on a certain set of "current" solutions.
Sometimes, the best-so-far solution might be removed from that set.
This does *not* mean that it will be forgotten.
It will *always* be remembered somewhere.
The end result of every *reasonable* implementation of any optimization algorithm will return the best solution encountered.
An implementation that does not do this is wrong.


### Randomization {#sec:randomizedAlgos}

Often, metaheuristics make randomized choices.
In cases where it is not clear whether doing "A" or doing "B" is better, it makes sense to simply flip a coin and do "A" if it is heads and "B" if it is tails.

Why does this make sense?
Well, imagine that you have a situation where your algorithm could either do "A" or "B" and it is indeed not clear (at algorithm design or implementation time) which one is best.
You decide to hard-code that it should always do "A."
Now what if "B" was better?
Then your algorithm always picks the worse one of the two choices.
If you hard-code to always to "B," you have essentially the same situation.
If you let your algorithm to choose randomly whether to do "A" or "B," you can at least avoid the situation that it *always* picks the worst option.

That our search operator APIs in [@lst:op0;@lst:op1;@lst:op2] all accept a pseudorandom number generator&nbsp;$\random$ as parameter is one manifestation of this issue.
Random number generators are objects which provide functions that can return numbers from certain ranges, say from $[0,1)$ or an integer interval.
Whenever we call such a function, it may return any value from the allowed range, but we do not know which one it will be.
The returned value should be independent of those returned before, i.e., from known the past random numbers, we should *not* be able to guess the next one.
By using such random number generators, we can let an algorithm make random choices, randomly pick elements from a set, or change a variable's value in some unpredictable way.  


### Black-Box Optimization {#sec:blackbox}

\rel.figure{black_box_metaheuristic}{The black-box character of many metaheuristics, which can often work with arbitrary search operators, representations, and objective functions.}{black_box_metaheuristic.svgz}{width=70%}

The idea behind general metaheuristics is to attack a very wide class of optimization problems with one basic algorithm design.
This can be realized when following a *black-box* approach.
If we want to have one algorithm that can be applied to all the examples given in the introduction [@sec:intro:examples], then this can best be done if we hide all details of the problems under the hood of the structural elements introduced in [@sec:structure].
For a black-box metaheuristic, it does not matter how the objective function&nbsp;$\objf$ works.
The only thing that matters is that gives a rating of a candidate solution&nbsp;$\solspel\in\solutionSpace$ and that smaller ratings are better.

There are different degrees of how general black-box metaheuristics can be.
For the most general algorithms, it does not matter what exactly the search operators do or even what data structure is used as search space&nbsp;$\searchSpace$.
For them, it only matters that these operators can be used to get to new points in the search space (which can be mapped to candidate solutions&nbsp;$\solspel$ via a representation mapping&nbsp;$\encoding$ whose nature is also unimportant for the metaheuristic).
Then, even the nature of the candidate solutions&nbsp;$\solspel\in\solutionSpace$ and the solution space&nbsp;$\solutionSpace$ play no big role for black-box optimization methods, as they only work on and explore the search space&nbsp;$\searchSpace$.

Then there are also black-box metaheuristics that demand a special type of search space, e.g., a specific subset of the $n$-dimensional real numbers ($\searchSpace\subset\realNumbers^n$), bit strings of a given length, or permutations of the first $n$&nbsp;natural numbers.
These algorithms can still be general, as they may make very few assumptions about the nature of the objective function&nbsp;$\objf$ defined over the solution space&nbsp;$\solutionSpace$.

The solution space is relevant for the human operator using the algorithm only, the search space is what the algorithm works on.
Of course, in many cases, $\searchSpace=\solutionSpace$.

Thus, a black-box metaheuristic is a general algorithm into which we can plug representations, objective functions, and often also search operations as needed by a specific application.
This is illustrated in [@fig:black_box_metaheuristic].
Black-box optimization is the highest level of abstraction on which we can work when trying to solve complex problems.


### Putting it Together: A simple API {sec:blackBoxProcessAPI}

Before, I promised that we will implement all the algorithms discussed in this book.

If we would be dealing with "classical" algorithms, things would be somewhat easier:
A classical algorithm has clearly defined input and output data structures.
Dijkstra's shortest path algorithm&nbsp;[@D1959ANOTPICWG], for instance, gets fed with a graph of weighted edges and a start node and will return the paths of minimum weight to all other nodes (or a specified target node).
In Machine Learning, the situation is quite similar:
We would have a lot of specialized algorithms for clearly defined situations.
The input and output data would usually adhere to some basic, fixed structures.
If you implement $k$-means clustering&nbsp;[@F1965CAOMDEVIOC; @HW1979AA1AKMCA], for instance, you have real vectors coming in and $k$&nbsp;real vectors going out of your algorithm and that's that.
Deep Learning&nbsp;[@GBC2016DL] often takes a set of labeled real vectors (plus a network structure) as input and produces the vector of weights for the network as output.

We, however, have to deal with the black-box concept, meaning that our algorithms will be very variable in terms of the data structures we can feed to them.
Matter in fact:
*Any* of the three scenarios above can be modeled as optimization problem.
*Any* of them can be tackled with (most of) the metaheuristics in this book as well!

This is challenging from a programming perspective, especially when we try to tackle this in an educational setting, where stuff should not be overly complicated.
What we want is to not just implement general algorithms, but also be able to execute them and obtain their results in a convenient fashion.
Ideally, we do not want to be bothered with too much bookkeeping or the creation of log files and such and such.
It should be possible to implement the most general type of black-box methods as well as problem-specific optimization methods and to run them in a uniform environment. 

I therefore try to define a simple API for black-box optimization that combines all of our considerations far.
The goal is to make two things very easy:

1. the implementation of metaheuristics and
2. the experimentation with metaheuristics.

We do this by clearly dividing three things:

1. the structural components of the problem that we discussed in [@sec:structure],
2. the optimization algorithms that use them (which we will introduce in this chapter), and
3. the execution of experiments, the logging of results, and evaluation of the results.

The algorithms that we will implement will be general black-box methods.
At the same time, we will develop the components that we need to plug into them to solve JSSPs as educational example.
In this book, we will not really care much about the third point &ndash; but in our [\repo{mp}{repo.name}](\repo{mp}{repo.url}) package, you can find all the implementations and code.
Here, we will only very shortly outline them.

\git.code{mp}{Process}{An excerpt of the base class for the Process API.}{moptipy/api/process.py}{}{book}{format}

\git.code{mp}{Algorithm}{An excerpt of the base class for the API for implementing optimization algorithms.}{moptipy/api/algorithm.py}{}{book}{doc,hints}

The core component for executing experiments is the class `Process`, a part of which is illustrated in [@lst:Process].
Instances of this class are passed to the optimization algorithm implementations that inherit from class `Algorithm` given in [@lst:Algorithm].
It inherits from `Space` (see [@lst:Space]) and provides all of its method to directly access the search space&nbsp;$\searchSpace$.
And algorithm can therefore use an instance of `Process` to create and copy points in the search space.
`Process` also inherits from `Objective` (see [@lst:Objective]).
It represents a wrapper&nbsp;$\objf':\searchSpace\mapsto\realNumbers$ that embodies both the encoding and the original objective function, i.e., $\objf'(\sespel)=\objf(\encoding(\sespel))\;\forall\sespel\in\searchSpace$.
This means that an optimization algorithm indeed only needs to care about the search space and has basically no contact with the solution space&nbsp;$\solutionSpace$.

Since `Process` forwards calls of `evaluate` (again, see [@lst:Objective]), it has one other advantage:
It will see all the solutions that the algorithm evaluates *and* all of their objective values.
Hence, it can easily remember the best-so-far solution and even log improvements to log files if we want.
The optimization algorithm can thus query the `Process` for a copy of the best-so-far solution.
Once the algorithm has completed, the user can ask the `Process` for a copy of the final result, too.

`Process` can also count the number of evaluated solutions, check if any goal quality was reached, and observe the runtime that has been consumed.
It therefore also provides a function `should_terminate` representing the termination criterion discussed in [@sec:terminationCriterion].
Finally, a `Process` also provides a source for randomness&nbsp;$\random$ (see [@sec:randomizedAlgos]) that the algorithm can use for all of its non-deterministic decisions.

As said, I will not go into detail much how this functionality is implemented.
You can read this in the documentation of our library, if you want.
The important point is:
With the structural components discussed in [@sec:structure] and the blueprint of the most trivial class for implementing an optimization algorithm given in [@lst:Algorithm], we can now finally move forward and begin implementing actual algorithms.
