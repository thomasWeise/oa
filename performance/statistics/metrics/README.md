### Statistical Metrics used in this Book {#sec:statisticalMetrics}

Our book here is intended to provide hands-on experience with optimization.
Therefore, if we discuss algorithms, we also implement them and conduct some experiments to explore their behavior.
We therefore present simple statistics to get an impression of the performance.
In this book, we use the following measures and notations:

First, we can compute statistics on the best objective values reached by the single runs of optimization algorithms:

- "$\minBestF$" is the objective value of the best solution discovered by any run of a specific algorithm setup on a specific problem instance&nbsp;$\instance$. 
- "$\meanBestF$" is the arithmetic mean of the objective values of the best solution discovered by each run on a specific problem instance&nbsp;$\instance$.
- "$\stddevBestF$" is the standard deviation of the objective values of the best solution discovered by each run on a specific problem instance&nbsp;$\instance$.

In many situations, we know lower bounds or even the optimal solutions for the problem instances we are experimenting with.
Then we can divide the best achieved objective values of each run by lower bounds of the corresponding problem instances.
We will obtain "scaled" objective values that will tell us how good an algorithm performs at first glance:
A scaled objective value of&nbsp;1 is optimal, a scaled objective value of&nbsp;2 means that the result is twice as costly as the theoretical optimum, and so on.
We can compute the following statistics on such scaled objective values:

- "$\minBestFscaled$" is the best scaled objective value of the best solution discovered by any run of a specific algorithm setup on a specific problem instance&nbsp;$\instance$ or set of instances.  
- "$\meanBestFscaled$" is the arithmetic mean of the objective values of the best solutions discovered by each run of a specific algorithm setup on a specific problem instance&nbsp;$\instance$.  
- "$\geomeanBestFscaled$" is the arithmetic mean of the objective values of the best solutions discovered by each run of a specific algorithm setup on a specific problem instance&nbsp;$\instance$ or set of instances.
  We use the geometric mean because is preferable when aggregating results that have been scaled with different factors (such as different lower bounds), as discussed in [@sec:averages].
- "$\maxBestFscaled$" is the worst scaled objective value of the best solution discovered by any run of a specific algorithm setup on a specific problem instance&nbsp;$\instance$ or set of instances.
- "$\stddevBestFscaled$" is the standard deviation of the scaled objective values of the best solution discovered by each run on a specific problem instance&nbsp;$\instance$ or instance set.

If we want to investigate the total runtime consumed, we may present the following statistics:

- "$\meanTotalMS$" is the arithmetic mean of the total time consumed by each run, measured in milliseconds.
