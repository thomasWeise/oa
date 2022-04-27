### Averages: Arithmetic Mean vs. Median vs. Geometric Mean {#sec:averages}

Assume that we have obtained a sample&nbsp;$A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1})$ of $n$&nbsp;observations from an experiment, e.g., we have measured the quality of the best discovered solutions of 11&nbsp;independent runs of an optimization algorithm.
We usually want to get reduce this set of numbers to a single value which can give us an impression of what the "average outcome" (or result quality) is.

We could just report the best solution encountered over all runs, but this would not be a good idea&nbsp;[@BD2007HTAARTPOASAOAPMOBROANOR; @J2002ATGTTEAOA].
First, it would not really tell us about the performance of our algorithm, but about our algorithm *with restarts*.
Second, the best result over many runs could also be a fluke, e.g., just one lucky hit that will not occur again.
Third, the best encountered solution is just one value from&nbsp;$n$ runs which is not influenced by the results of the other $n-1$&nbsp;runs.
It is not a bad idea to report the best solution encountered in the runs, especially if it is better or equally good than the best known solutions (BKS) for a given problem&nbsp;[@IJG2016MPOOAIEC].
However, reporting *only* the best result is overly optimistic and we need some other indicator for the average performance that we can expect.
 
Three of the most common options for this purpose, for estimating a central value of a distribution, are the *arithmetic mean*, the *median*, and the *geometric mean*.


#### Arithmetic Mean and Median {#sec:meanAndMedian}

\definition{def}{arithmeticMean}{The arithmetic mean $\mean(A)$ is an estimate of the expected value of a data sample $A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1})$.
It is computed as the sum of all&nbsp;$n$ elements&nbsp;$\arrayIndex{a}{i}$ in the sample data&nbsp;$A$ divided by the total number&nbsp;$n$ of values.}

$$ \mean(A) = \frac{1}{n} \sum_{i=0}^{n-1} \arrayIndex{a}{i} $$
 
\definition{def}{median}{The median $\median(A)$ is the value separating the bigger half from the smaller half of a data sample or distribution.
It is the value right in the middle of a *sorted* data sample $A=(\arrayIndex{a}{0},\arrayIndex{a}{1}, \dots, \arrayIndex{a}{n-1})$ where $\arrayIndex{a}{i-1}\leq \arrayIndex{a}{i}$&nbsp;$\forall i \in \intRange{1}{(n-1)}$.}

$$ \median(A) = \left\{\begin{array}{ll}
\arrayIndex{a}{\frac{n-1}{2}} & \text{if }n\text{ is odd}\\
\frac{1}{2}\left(\arrayIndex{a}{\frac{n}{2}-1} + \arrayIndex{a}{\frac{n}{2}}\right) & \text{otherwise}
\end{array}\right. \quad \text{if~}\arrayIndex{a}{i-1}\leq \arrayIndex{a}{i} \; \forall i \in \intRange{1}{(n-1)}$$ {#eq:median}

Notice the zero-based indices in our formula, i.e., the data samples&nbsp;$A$ start with&nbsp;$\arrayIndex{a}{0}$.
Of course, any data sample can be transformed to a sorted data sample fulfilling the above constraints by, well, sorting it.

We may now ask:
Why are we considering two measures of the average, the arithmetic mean and the median?
Which one is better?
Which one should I take?

This question is actually hard to answer.
It very much depends on your application.
In particular, it depends very much on the question of whether or not your data might contain outliers and &dash; very important &ndash; what could cause these outliers?


#### Outliers and their influence on the arithmetic mean

Let us consider two example data sets&nbsp;$A$ and&nbsp;$B$, both with $n_A=n_B=19$ values, only differing in their largest observation:

- $A=(1, 3, 4, 4, 4, 5, 6, 6, 6, 6, 7, 7, 9, 9, 9, 10, 11, 12, 14)$
- $B=(1, 3, 4, 4, 4, 5, 6, 6, 6, 6, 7, 7, 9, 9, 9, 10, 11, 12, 10'008)$

We find that:

- $\mean(A)=\frac{1}{19}\sum_{i=0}^{18} \arrayIndex{a}{i} = \frac{133}{19} = 7$ and
- $\mean(B)=\frac{1}{19}\sum_{i=0}^{18} \arrayIndex{b}{i} = \frac{10127}{19} = 553$, while
- $\median(A)=\arrayIndex{a}{9} = 6$ and
- $\median(B)=\arrayIndex{b}{9} = 6$.

The value $\arrayIndex{b}{18}=10'008$ is an unusual value in&nbsp;$B$.
It is about three orders of magnitude larger than all other measurements.
Its appearance has led to a complete change in the average computed based on the arithmetic mean in comparison to dataset&nbsp;$A$, while it had no impact on the median.

We often call such odd values outliers&nbsp;[@G1969PFDOOIS; @M1992ITE].
They sometimes may represent measurement errors or observations which have been been disturbed by unusual effects.
In our experiments on the JSSP, for instance, some runs may perform unexpectedly few function evaluations, maybe due to scheduling issues.
As a result, some runs might perform worse, because they receive fewer FEs.

Outliers may have a big impact on the arithmetic mean and no influence on the median.
What does that mean?
Do we want our measure of average to be influenced by outliers or not?

This very much depends on the source of outliers.
Let's say you are a biologist and want to count ants per square meters of a lawn.
There can be lots of totally uncontrollable factors that influence the outcome.
Maybe an ant eater has passed through and ate all the ants of one the lawn cells and then left.
Such factors are probably not what you are after.
You would probably want a representative value and do not care about outliers very much. 
Then, you prefer statistical measures, which do not suffer too much from anomalies in the data.
You would prefer the median.

For example, in&nbsp;[@R2011WDEGMFA] we find that the annual average income of all families in the USA grew by&nbsp;1.2% per year from 1976 to 2007.
This mean growth, however, is not distributed evenly, as the top-1% of income recipients had a 4.4%&nbsp;per-year growth while the bottom&nbsp;99% could only improve by&nbsp;0.6% per year.
The arithmetic mean does not necessarily give an indicator of the range of the most likely observations to encounter.
The median would show us that, for normal people, the income did not really grow significantly.


#### Why outliers are important in experiments with optimization algorithms

But there are also scenarios where outliers contain important information, e.g., represent some unusual side-effect in a clinical trial of a new medicine.
**Actually, in our domain &ndash; optimization &ndash; outliers will very often give us very important information.**

When we measure the performance of an algorithm implementation, there are few possible sources of "measurement errors" apart from unusual scheduling delays and even these cannot occur if we measure runtime in FEs.
If there are unusually behaving runs, then the most likely source is a bug in the algorithm implementation!
In [@sec:unit_testing_and_analysis], we have discussed that it is hard to unsure that soft computing methods are implemented correctly.  
If the cause of the outlier is not a bug, then the second most likely source is that our algorithm has a bad worst case behavior.
We do want to know this.
Thus, we must check the arithmetic mean.

Let us take the MAX-SAT problem, an $\NPprefix$-hard problem.
If we apply a local search algorithm to a set of different MAX-SAT instances, it may well be that the algorithm requires exponential runtime on 25% of them while solving the others in polynomial time.
This was the case, for example, in the experiments presented on page&nbsp;46 of the research paper&nbsp;[@HS2000LSAFSAEE].
If we consider only the median runtime, it would appear that we could solve an $\NPprefix$-hard problem in polynomial time, as the median is not influenced by the worst 25% of the runs&hellip;
In other words, our conclusion would be quite spectacular, but also quite wrong.
The arithmetic mean is much more likely to be influenced by the long runs.
Only if we compute the mean over sufficiently many runs, we can see that our algorithm, in average, still needs exponential time.

In optimization, the quality of good results is limited by the quality of the global optimum.
Most reasonable algorithms will give us solutions not too far from it (but obviously never anything better).
In such a case, the objective function appears almost "unbounded" towards worse solutions.
The real upper bound of the objective function, i.e., the worst possible objective value, will normally be very far away from what the algorithm tends to deliver.
This means that we may likely encounter algorithms that often give us very good results (close to the lower bound) but rarely also bad results, which can be far from the bound.
Thus, the distribution of the final result quality might be skewed, too.
Thinking that we will most often get results similar to the arithmetic mean might then be wrong.


#### Summary: Arithmetic Mean vs. Median

Both the arithmetic mean and median carry useful information.
The median tells us about values we are likely to encounter if we perform an experiment once.
It is robust against outliers and unusual behaviors.
The arithmetic mean tells us about the average performance if we perform the experiment many times&nbsp;[@IJG2016MPOOAIEC].
If we try to solve 1000&nbsp;problem instances, the overall time we will need will probably be similar to 1000&nbsp;times the arithmetic mean time we observed in our previous experiments.
It also incorporates information about odd, rarely occurring situations while the median may "ignore" phenomena even if they occur in one third of the samples.
If the outcome in such situations is bad, then it is good to have this information.

Today, the median is often preferred over the mean because it is a robust statistic.
Actually, I myself often preferred it in the past.
The fact that skewed distributions and outliers have little impact on it makes it very attractive to report average result qualities.
There is no guarantee whatsoever that a solution of mean quality exists in an experiment.

However, the weakness of the arithmetic mean, i.e., the fact that every single measured value does have an impact on it, can also be its strength:
If we have a bug in our algorithm implementation that only very rarely has an impact on the algorithm behavior and that only in these very few cases leads unexpectedly bad results, this will show up in the mean but not in the median.
If our algorithm on a few problem instances needs particularly long to converge, we will see it in the mean but not in the median.
*For this reason, I now find the mean to be the more important metric.*

There is one more issue though:
Let us say that we do not average result qualities, but times measured to reach certain goal, i.e., apply the horizontal performance view.
If one run fails, then the arithmetic mean becomes undefined, which is a problem&nbsp;[@I1971OTEOSFCAP].
The median will remain defined as long as at least half of the runs succeed.

Well.
We do not need to decide which is better.
I think there is no reason for us to limit ourselves to only one measure of the average.
I suggest to report both, the median and the mean, to be on the safe side &ndash; as we did in our JSSP experiments.
Indeed, the maybe best idea would be to consider both the mean and median value and then take the worst of the two.
This should always provide a conservative and robust outlook on algorithm performance. 


#### The Geometric Mean and Scaled Data {#sec:geometricMean}

So far, we have discussed the arithmetic mean and the median.

\definition{def}{geometricMean}{The sample *geometric mean*&nbsp;$\geomean(A)$ is the $n$^th^ root of the product of the $n$ **positive** values $\arrayIndex{a}{i}$ (with $i\in 0\ldots(n-1)$) in&nbsp;$A$.}

The geometric mean is always smaller than (or equal to) the arithmetic mean&nbsp;[@C1981CDADLERPIPAA].
It can be computed as follows:

$$ \geomean(A) = \sqrt[n]{\prod_{i=0}^{n-1} \arrayIndex{a}{i}} $$ {#eq:geomean1}
$$ \geomean(A) = \exp{\left(\frac{1}{n} \sum_{i=0}^{n-1} \log{\arrayIndex{a}{i}} \right)} $$ {#eq:geomean2}

[@eq:geomean1] and [@eq:geomean2] are equivalent.
Both of them require that $\arrayIndex{a}{i}>0$&nbsp;$\forall i\in 0\ldots(n-1)$.
If the values $\arrayIndex{a}{i}$ are either all big, all small, or many, then we may get floating point precision problems when computing the product in [@eq:geomean1].
[@eq:geomean2] avoids this by summing up over logarithms.

But what do we need the geometric mean for?
Let us approach this question by looking at a simple example experiment.
Imagine that we solve the JSSP instances&nbsp;$\instance_1$ to&nbsp;$\instance_3$ with the different algorithms&nbsp;$\algorithmStyle{A}_1$ to&nbsp;$\algorithmStyle{A}_3$.
We stop the algorithms once they reach a given goal quality&nbsp;$\goalF$.
We measure the runtimes they need to reach the goal, i.e., aim for the horizontal cut scheme introduced in [@sec:performanceIndicators:horizontalCut].
We get the results presented in [@tbl:geometric_mean_example_1]:
Here, the arithmetic mean and, the median, and the geometric mean values of these runtimes are the same.
We can conclude that the three algorithms offer the same performance in average over these benchmark instances.

| | $\algorithmStyle{A}_1$ |$\algorithmStyle{A}_2$ | $\algorithmStyle{A}_3$ |
|--:|--:|--:|--:|
$\instance_1$ | 10.00&nbsp;s | 20.00&nbsp;s | 40.00&nbsp;s |
$\instance_2$ | 20.00&nbsp;s | 40.00&nbsp;s | 10.00&nbsp;s |
$\instance_3$ | 40.00&nbsp;s | 10.00&nbsp;s | 20.00&nbsp;s |
$\mean$:      | 23.33&nbsp;s | 23.33&nbsp;s | 23.33&nbsp;s |
$\median$:    | 20.00&nbsp;s | 20.00&nbsp;s | 20.00&nbsp;s |
$\geomean$:   | 20.00&nbsp;s | 20.00&nbsp;s | 20.00&nbsp;s |

: The runtimes measured for algorithms $\algorithmStyle{A}_1$ to $\algorithmStyle{A}_2$ on problem instances $\instance_1$ to $\instance_3$. All algorithms have the same arithmetic mean, median, and geometric mean runtime requirements. {#tbl:geometric_mean_example_1}

Often, the measured numbers "look messier" and the relationships of the numbers are not so obvious.
Often, we use more instances and algorithms. 
It becomes harder to see whether and which algorithms perform different, better, worse, or equal.
Thus, we may often want to scale them by picking one algorithm as "standard" and dividing them by its measurements.
Let's say $\algorithmStyle{A}_1$ was a well-known heuristic.
We want to use it as baseline for comparison and scale our data by it.

| | **$\algorithmStyle{A}_1$** |$\algorithmStyle{A}_2$ | $\algorithmStyle{A}_3$ |
|--:|--:|--:|--:|
$\instance_1$ | 1.00 | 2.00 | 4.00 |
$\instance_2$ | 1.00 | 2.00 | 0.50 |
$\instance_3$ | 1.00 | 0.25 | 0.50 |
$\mean$:      | 1.00 | 1.42 | 1.67 |
$\median$:    | 1.00 | 2.00 | 0.50 |
$\geomean$:   | 1.00 | 1.00 | 1.00 |

: The data from [@tbl:geometric_mean_example_1], but scaled based on&nbsp;$\algorithmStyle{A}_1$: The runtimes for each instance are divided by the values measured for runtimes measured for algorithm&nbsp;$\algorithmStyle{A}_1$. Now $\algorithmStyle{A}_1$ has the best and $\algorithmStyle{A}_3$ has the worst arithmetic mean, $\algorithmStyle{A}_3$ has the best and $\algorithmStyle{A}_2$ the worst median. {#tbl:geometric_mean_example_2}

OK, so we get the [@tbl:geometric_mean_example_2] with scaled values, which allow us to make sense of the data at first glance.
If we now compute the arithmetic mean, then algorithm&nbsp;$\algorithmStyle{A}_1$ seems best and algorithm&nbsp;$\algorithmStyle{A}_3$ looks worst.
According to the median, however, $\algorithmStyle{A}_3$ would be best and $\algorithmStyle{A}_2$ appears to be the worst.
Only the geometric mean still indicates that the algorithms perform the same&hellip;


| | $\algorithmStyle{A}_1$ | **$\algorithmStyle{A}_2$** | $\algorithmStyle{A}_3$ |
|--:|--:|--:|--:|
$\instance_1$ | 0.50 | 1.00 | 2.00 |
$\instance_2$ | 0.50 | 1.00 | 0.25 |
$\instance_3$ | 4.00 | 1.00 | 2.00 |
$\mean$:      | 1.67 | 1.00 | 1.42 |
$\median$:    | 0.50 | 1.00 | 2.00 |
$\geomean$:   | 1.00 | 1.00 | 1.00 |

: The data from [@tbl:geometric_mean_example_1], but scaled based on&nbsp;$\algorithmStyle{A}_2$: The runtimes for each instance are divided by the values measured for runtimes measured for algorithm&nbsp;$\algorithmStyle{A}_2$. Now $\algorithmStyle{A}_2$ has the best and $\algorithmStyle{A}_1$ has the worst arithmetic mean, $\algorithmStyle{A}_1$ has the best and $\algorithmStyle{A}_3$ the worst median. {#tbl:geometric_mean_example_3}

If we scaled based on algorithm&nbsp;$\algorithmStyle{A}_2$ instead, we get [@tbl:geometric_mean_example_3].
Now, judging by the arithmetic mean, then $\algorithmStyle{A}_2$ seems to be best and $\algorithmStyle{A}_1$ looks worst.
However, according to the median, $\algorithmStyle{A}_1$ would be best and $\algorithmStyle{A}_2$ appears to be the worst.
Again only the geometric mean still indicates that the algorithms perform the same.

We can conclude:
Almost arbitrary conclusions can be reached based on the arithmetic mean and the median if the data is scaled.
This means that if the data is scaled, these two averages are not useful. 
The geometric mean is the only meaningful average if we have scaled data&nbsp;[@FW1986HNTLWSTCWTSBR].

We very often have scaled data.
For example, at least half of the papers on the Job Shop Scheduling Problem scaled the result qualities they obtain on benchmark instances with a Best Known Solutions (BKS) or the highest lower bound at the time when they were written.
And many of them then compute the arithmetic mean&hellip;

Then again, using the geometric mean also has some severe downsides&nbsp;[@V2022TGM]:
The geometric mean is very sensitive to the underlying probability distribution and its skewness.
Its estimator ([@eq:geomean1; @eq:geomean2]) exhibits considerable bias under small samples.


#### Summary

We want to represent the central trend of a performance indicator.
There is no simple answer on which measure of the average we should use.

A simple fact is this:
Most publications report arithmetic mean results, many report median results, almost none report geometric means.

The median is more robust against outliers compared to the arithmetic mean.
However, in application scenarios of optimization algorithms (or soft computing in general), there are very few acceptable reasons for outliers.
We therefore want to know *both* the arithmetic mean and the median:
If the arithmetic mean is much worse than the median, then maybe we have a bug in our code that only sometimes has an impact or our algorithm has a bad worst-case behavior (which is also good to know).
If the median is much worse than the mean, then the mean is too optimistic, i.e., most of the time we should expect worse results.
If there are outliers, the value of the arithmetic mean itself may be very different from any actually observed value, while the median is (almost always) similar to some actual measurements.

Often, our data is implicitly or explicitly scaled, e.g.,

- if we divide result qualities by results of well-known heuristics or best-known solutions or
- if we scale the runtime using another algorithm as standard.

Then, the arithmetic mean and median can be very misleading and the geometric mean needs be computed.
However, the estimated geometric mean may be biased if we only have few runs.

I think:
On raw data, we should compute all three measures of average, and pay special attention to the one looking the worst. 
On scaled data, we should compute the geometric mean, but also consider the arithmetic mean and median if and only if they make our algorithm look worse.
Especially if we compare with existing methods, it is better to take the pessimistic stance.
