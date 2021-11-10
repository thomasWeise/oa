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
We know and understand these spaces since high school.
Then we have all kinds of tools available, ranging from distance metrics to vector mathematics, to search in it in an ordered fashion. 

For applying an optimization algorithm, we usually choose a data structure&nbsp;$\searchSpace$ which we can understand intuitively.
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

