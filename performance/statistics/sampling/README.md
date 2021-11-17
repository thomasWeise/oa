### Statistical Samples vs. Probability Distributions

For each optimization problem there are several instances.
Some instances will be easy to solve, some will be hard.
We always must use multiple different problem instances in our experiments to get reliable results and a clear understanding of the algorithm performance.
The performance indicators need to be computed for each instance and also summarized over several instances.

Furthermore, our algorithms are *randomized*, meaning that different runs may yield different results.
Let us here clarify first the difference between a probability distribution and data sample.

\definition{def}{probabilityDistribution}{A *probability distribution*&nbsp;$F$ is an assignment of probabilities of occurrence to different possible outcomes in an experiment.}

\definition{def}{sample}{A *random sample* of length&nbsp;$k\geq 1$ is a set of $k$&nbsp;independent observations of an experiment following a random distribution&nbsp;$F$.}

\definition{def}{observation}{An *observation* is a measured outcome of an experiment or random variable.}

The specification of an optimization algorithm together with its input data, i.e., the problem instance to which it is applied, defines a probability distribution over the possible values that a performance indicator can take on.
Each run allows us to make an observation of the performance indicator.
At least theoretically, one could develop a mathematical formula for the probability of every possible makespan that a hill climber with a given unary operator could produce on the `swv15` JSSP instance within 100'000&nbsp;FEs.
Then, we could say something like:
"With 4% probability, we will find a Gantt chart with a makespan of 2885 time units within 100'000&nbsp;FEs."
In an ideal world, we could define such probability distributions for all algorithms.
Then, we would know absolutely which algorithm will be the best for which problem.

However, I do not possess sufficient theoretical and mathematical skills to do that.
So far, nobody seems to possess them.
Significant advances have been made in modeling and deriving statistical properties of algorithms for various optimization problems.
However, for most practically relevant problems and algorithms, we are very far from being able to derive result distributions or expectations for runtimes and solution qualities.
We cannot obtain the actual probability distributions describing the results.
We can, however, try to *estimate* their parameters by running experiments and measuring results, i.e., by sampling the results. 

|\#&nbsp;throws|number|$f_1$|$f_2$|$f_3$|$f_4$|$f_5$|$f_6$|
|--:|:-:|--:|--:|--:|--:|--:|--:|
|1|5|0.0000|0.0000|0.0000|0.0000|1.0000|0.0000|
|2|4|0.0000|0.0000|0.0000|0.5000|0.5000|0.0000|
|3|1|0.3333|0.0000|0.0000|0.3333|0.3333|0.0000|
|4|4|0.2500|0.0000|0.0000|0.5000|0.2500|0.0000|
|5|3|0.2000|0.0000|0.2000|0.4000|0.2000|0.0000|
|6|3|0.1667|0.0000|0.3333|0.3333|0.1667|0.0000|
|7|2|0.1429|0.1429|0.2857|0.2857|0.1429|0.0000|
|8|1|0.2500|0.1250|0.2500|0.2500|0.1250|0.0000|
|9|4|0.2222|0.1111|0.2222|0.3333|0.1111|0.0000|
|10|2|0.2000|0.2000|0.2000|0.3000|0.1000|0.0000|
|11|6|0.1818|0.1818|0.1818|0.2727|0.0909|0.0909|
|12|3|0.1667|0.1667|0.2500|0.2500|0.0833|0.0833|
|100|&hellip;|0.1900|0.2100|0.1500|0.1600|0.1200|0.1700|
|1'000|&hellip;|0.1700|0.1670|0.1620|0.1670|0.1570|0.1770|
|10'000|&hellip;|0.1682|0.1699|0.1680|0.1661|0.1655|0.1623|
|100'000|&hellip;|0.1671|0.1649|0.1664|0.1676|0.1668|0.1672|
|1'000'000|&hellip;|0.1673|0.1663|0.1662|0.1673|0.1666|0.1664|
|10'000'000|&hellip;|0.1667|0.1667|0.1666|0.1668|0.1667|0.1665|
|100'000'000|&hellip;|0.1667|0.1666|0.1666|0.1667|0.1667|0.1667|
|1'000'000'000|&hellip;|0.1667|0.1667|0.1667|0.1667|0.1667|0.1667|

: The results of one possible outcome of an experiment with several simulated dice throws. The number&nbsp;*\# throws* and the thrown *number* are given in the first two columns, whereas the relative frequency of occurrence of number&nbsp;$i$ is given in the columns&nbsp;$f_i$. {#tbl:diceThrow}

Imagine that we are throwing an ideal dice.
Each number from one to six has the same probability to occur, i.e., the probability $\frac{1}{6}=0.1\overline{6}$.
If we throw a dice a single time, we will get one number.
If we throw it twice, we see two numbers.
Let&nbsp;$f_i$ be the relative frequency of each number in $k=\text{\# throws}$ of the dice, i.e., $f_i=\frac{\text{number of times we got }i}{k}$.
The more often we throw the dice, the more similar to&nbsp;$\frac{1}{6}$ should&nbsp;$f_i$ become, as illustrated in [@tbl:diceThrow] for a simulated experiments of many dice throws.

As can be seen in [@tbl:diceThrow], the first ten or so dice throws tell us little about the actual probability of each result.
However, when we throw the dice many times, the observed relative frequencies become more similar to what we expect.
There are two take-away messages from this section:

1. It is *never* enough to just apply an optimization algorithm once or twice to a problem instance to get a good impression of a performance indicator (unless you have very many different problem instances).
   It is a good rule of thumb to always perform at least ten independent runs.
   In our experiments on the JSSP, for instance, we do eleven runs per problem instance.
2. We can *estimate* the performance indicators of our algorithms or their implementations via experiments, but we will not know their true value.
   Our observations may differ from actual parameters of the performance indicator distributions.   
