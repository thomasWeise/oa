# Measuring Performance and Comparing Optimization Algorithms {#sec:comparingOptimizationAlgorithms}

In this book, we learn learned quite a few different approaches for solving optimization problems.
Whenever we introduce a new algorithm, we need to compared it with some of the methods we have discussed before.

Clearly, when approaching an optimization problem, our goal is to solve it in the best possible way.
What the best possible way is will depend on the problem itself as well as the framework conditions applying to us, say, the computational budget we have available.

There are three key elements that complicate understanding the performance of an algorithm:

1. Our algorithms are randomized and may do different things and thus may yield different results even if applied to the same problem instance.
2. Our algorithms progress iteratively and improve their best-so-far solution over time, i.e., may yield different results depending on the computational budget we provide.
3. Our algorithms do not guarantee to find the globally optimal solution but usually return only good approximate solutions.

It is important to understand that *performance* is almost always *relative*.
If we have only a single method that can be applied to an optimization problem, then it is neither good nor bad, because we can either take it or leave it. 
Instead, we often start by first developing one idea and then try to improve it.
Of course, we need to compare each new approach with the ones we already have.
Alternatively, especially if we work in a research scenario, maybe we have a new idea which then needs to be compared to a set of existing state-of-the-art algorithms.
The art of assessing the performance of algorithms is a research field in itself&nbsp;[@MRS2021ATEOPBABA; @BBDvdBBCEFKLCLIMMNOVWW2020BIOBPAOIV2].

\rel.input{codingAndReproducibility/README.md}
\rel.input{time/README.md}
\rel.input{performanceIndicators/README.md}
\rel.input{statistics/README.md}
\rel.input{tests/README.md}
\rel.input{behavior/README.md}
