## Neutrality and Redundancy

An optimization problem and its representation have the property of causality if small changes in a candidate solution lead to small changes in the objective value.
If the resulting changes in the objective value are large, then causality is weak and the objective function is rugged, which has negative effects on optimization performance.
However, if the resulting changes in the objective value are *zero*, this can have a similar negative impact.  


### The Problem(?): Neutrality {#sec:neutrality:problem}

\rel.figure{increasing_neutrality}{An illustration of problems exhibiting increasing neutrality (from left to right).}{increasing_neutrality.svgz}{width=90%}

\definition{def}{neutrality}{*Neutrality* means that a large fraction of the points in neighborhood of a given point in the search space map to candidate solutions with the same objective value.}

From the perspective of an optimization process, exploring the neighborhood of a good solution will yield the same solution again and again, i.e., there is no direction into which it can progress in a meaningful way.
If half of the candidate solutions have the same objective value, then every second search step cannot lead to an improvement and, for most algorithms, does not yield useful information.
This will slow down the search.

\definition{def}{evolvability}{The *evolvability* of an optimization process in its current state defines how likely the search operations will lead to candidate solutions with new (and eventually, better) objectives values.}

While there are various slightly differing definitions of evolvability both in optimization and evolutionary biology (see&nbsp;[@H2010EAROEIEC]), they all condense to the ability to eventually produce better offspring.
Researchers in the late 1990s and early 2000s hoped that *adding* neutrality to the representation could increase the evolvability in an optimization process and may hence lead to better performance&nbsp;[@B1998RANTNKPFOFL; @S1999GRDOPFEA; @TI2002NANFSA].
A common idea on how neutrality could be beneficial was the that *neutral networks* would form connections in the search space&nbsp;[@B1998RANTNKPFOFL; @S1999GRDOPFEA].

\definition{def}{neutralNetwork}{*Neutral networks* are sets of points in the search space which map to candidate solutions of the same objective value and which are transitively connected by neighborhoods spanned by the unary search operator&nbsp;[@S1999GRDOPFEA].}

Careful:
We talk about *neutral network*, not *neural networks* from AI, which are something completely different.

The members of a neutral network may have neighborhoods that contain solutions with the same objective value (forming the network), but also solutions with worse and better objective values.
This is not the same as the "problematic" neutrality, because the number of solutions in the neighborhood with the same objective values does not necessarily need to be high.
An optimization process may drift along a neutral network until eventually discovering a better candidate solution, which then would be in a (better) neutral network of its own.

Such networks probably also exist in our encoding for the JSSP:
First, many Gantt charts that are similar may have the same objective value.
The makespan is only determined by the last operation that finishes (on the last machine).
Therefore, it may be possible to change the order of the operations on other machines that finish faster without any impact on the overall makespan.  
Second, our search space&nbsp;$\searchSpace$ is much larger than the solution space&nbsp;$\solutionSpace$, i.e., $|\searchSpace|\gg|\solutionSpace$.
There probably are intermediate unary search steps along which we can move in the search space without changing the encoded Gantt chart.
In [@sec:rls_results_on_jssp], we found that random local search (RLS) performs much better than hill climbers on the JSSP.
The only difference between them is that RLS permits neutral search moves and hill climbers do not.
Therefore, we can conclude that the neutral networks on the JSSP do not only exist, but may even be helpful during the optimization process.

The neutral networks in our encoding simply exist.
However, the question then arises how we can intentionally introduce a form of neutrality that is beneficial for the search into the search space and encoding.
How we can create useful neutral networks intentionally and in a controlled manner?
It was shown that random neutrality is not beneficial for optimization&nbsp;[@KW2002OTUOREIMBES].
Actually, there is no reason why neutral networks should provide a better method for escaping local optima than other methods, such as well-designed search operators, even if we could create them&nbsp;[@KW2002OTUOREIMBES].
Random, uniform, or non-uniform redundancy in the representation are not helpful for optimization&nbsp;[@R2006RFGAEA; @KW2002OTUOREIMBES] and should be avoided.

Another idea&nbsp;[@TI2002NANFSA] to achieve self-adaptation in the search is to encode the parameters of search operators in the points in the search space.
This means that, e.g., the magnitude to which a unary search operator may modify a certain decision variable is stored in an additional variable which undergoes optimization together with the "actual" variables.
Since the search space size increases due to the additional variables, this necessarily leads to some redundancy.
(We will discuss this useful concept when I get to writing a chapter on Evolution Strategy, which I will get to eventually, sorry for now.)


### Countermeasures

#### Representation Design

From [@tbl:jsspSearchSpaceTable] we know that in our job shop example, the search space is larger than the solution space.
Hence, we have some form of redundancy and neutrality.
We did not introduce this "additionally," however, but it is an artifact of our representation design with which we pay for a gain in simplicity and avoiding infeasible solutions.
Generally, when designing a representation, we should try to construct it as compact and non-redundant as possible.
A smaller search space can be searched more efficiently.   
