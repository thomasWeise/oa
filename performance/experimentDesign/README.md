## Designing Experiments

The topic of this chapter is how to measure the performance of an algorithm.
But actually, we never just measure performance.
This is never really our goal.

We always have a more general motive.
We want to know:
"Is algorithm&nbsp;$\algorithmStyle{A}$ better than algorithm&nbsp;$\algorithmStyle{B}$?"
or maybe
"Is this algorithm good enough for my use case?"
or maybe
"How should I set the parameters of my algorithm to get the best result within this runtime budget?"
Maybe we even have multiple questions that we want to answer in one go.

We then design an experiment to get an answer to our question(s).
How should we do that?
I believe there are some very simple steps to follow:

1. Clearly specify the research goal (e.g., design a good algorithm for problem&nbsp;$X$.
2. Clearly specify the research question to be answered by the experiment&nbsp;[@CDM1978RCEIMP], e.g.,
   a. Is algorithm&nbsp;$\algorithmStyle{A}$ better than algorithm&nbsp;$\algorithmStyle{B}$?
   b. Is this algorithm good enough for my use case?
   c. &hellip:
3. Design an experiment suitable to answer them, including:
   a. the choice of problems and problem instances or problem generators&nbsp;[@G1990CTWHAHM; @J2002ATGTTEAOA], which must be sufficient to investigate the research question thoroughly,
   b. the choice of algorithms (and their implementations),
   c. the choice of algorithm parameter settings,
   d. the choice of termination criteria,
   e. the choice of performance metrics,
   f. the choice of data to store and report from the experiments (such as random seeds, or additional data that could be useful later), and the
   g. the choice of the environment.
4. Choose under which conditions you would arrive at which conclusions, e.g.,
   a. thresholds&nbsp;$\alpha$ at which we can accept test results as significant (see [@sec:testForSignificance]),
   b. in how many problem instances should&nbsp;$\algorithmStyle{A}$ outperform algorithm&nbsp;$\algorithmStyle{B}$ to be considered as better?,
   c. &hellip;
5. Choose how you will evaluate the data reported from the experiments to be able to check the above conditions, e.g.,
   a. which diagrams will you draw,
   b. which tables you will print,
   c. which statistical tests you will use,
   d. &hellip;
   
