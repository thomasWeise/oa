## Software Development and Reproducibility

The very first and maybe one of the most important issues when evaluating an optimization algorithms is that you *never* evaluate an optimization algorithm.
You always evaluate an *implementation* of an optimization algorithm.
You always compare *implementations* of different algorithms.

Software development is an essential part of optimization.
This has several important implications.


### Unit Testing and Code Analysis {#sec:unit_testing_and_analysis}

Before we even begin to think about running experiments, we need to be sure that our algorithm implementations are correct.
In almost all cases, it is not possible to *prove* whether a software is implemented correctly or not.
In optimization, machine learning, AI, and basically all soft computing fields, we face several challenges that go beyond normal software development issues:

1. Most algorithms are randomized.
   Errors may not occur in a deterministic pattern but might appear spuriously and randomly.
2. Most algorithms are randomized.
   Their results and the quality of their results can be different for every single execution.
   This means that an error in the code &ndash; for instance, iterating from `i=1` to `n-1` instead of `i=0` to `n-1` in some loop &ndash; may just modify the distribution of the results and not cause the program to crash.
   Moreover, we often do not know the exact expected values of the distribution.
   Hence, finding an error that cause the results to deviate by 1% from an unknown correct value is *very* hard.
3. Many optimization algorithms are implemented by graduate students and young researchers who
   a) are not aware of the above,
   b) have no formal training in software engineering, and
   c) have very little experience with programming. 

In such a scenario, it is very important to develop a good coding discipline right from the start.
Despite the above problems, we can apply several measures to prevent and/or find potential errors.

A very important tool for this purpose is unit testing&nbsp;[@P2022PUTAAOAEUTIP; @S2021LTDDAPGTWUC].
Here, the code is divided into units, each of which can be tested separately.
In this book, we try to approach optimization in a structured way and have defined several abstract base classes for the components of an optimization and the representation in [@sec:structure].
An implementation of such a class can be considered as a unit.
The classes define methods with input and output values.
We now can write additional code that tests whether the methods behave as expected, i.e., do not violate their contract.
Such unit tests can be executed automatically.
Whenever we compile our software after changing code, we can also run all the tests again.
This way, we are very likely to spot a lot of errors before they mess up our experiments.

In the Python programming language, the software framework [pytest](http://pytest.org) provides an infrastructure for such testing&nbsp;[@O2017PTWPSREAS].
In the example codes of our book, in the folder [tests](\meta{repo.url}/tree/master/tests), we provide tests for general implementations of our base classes as well as for the classes we use in our JSSP experiment.

The encapsulation of different aspects of black-box optimization comes in handy for this.
If we can ensure that the implementations of all search operations, the representation mapping, and the objective function are correct, then our implemented algorithms will &ndash; at least &ndash; not return any invalid candidate solutions.
The reason is that they use exactly only these components to produce solutions.
A lot of pathological errors can therefore be detected early.

Besides unit testing, another set of tools we can use to reduce the chance of coding errors is static code analysis.
In our example implementation framework, we apply quite a few of them:
[flake8](https://flake8.pycqa.org/) enforces a proper coding style,
[pyflakes](https://pypi.org/project/pyflakes/), [pylint](https://pylint.org/), and [semgrep](https://pypi.org/project/semgrep/) search for well-known programming error patterns,
[mypy](http://mypy-lang.org/) performs static type checking to detect programming errors,
[bandit](https://pypi.org/project/bandit/) checks for security issues,
[pep257](https://pypi.org/project/pep257/) and [pydocstyle](http://www.pydocstyle.org/) check whether the documentation is formatted correctly, and
[pyroma](https://pypi.org/project/pyroma/) checks whether the project complies with standard packaging practices.

Always develop the tests either before or at least along with your algorithm implementation.
Always use as many static code analysis tools as you can get your hands on.
Never say "I will do them later."
Because you won't.
And if you actually would, you will find errors and then repeat your experiments.
Never the output of static analysis tools.
Because then errors will just aggregate and eventually become so many that fixing them becomes infeasible. 


### Reproducibility

A very important aspect of rigorous research is that experiments are *reproducible*&nbsp;[@J2002ATGTTEAOA; @GGA2018ORATRROSADSIAP].
The Terminology section of the "[Artifact Review and Badging](https://www.acm.org/publications/policies/artifact-review-and-badging-current)" documentation of the ACM&nbsp;[@ACM2020ARABV1] introduces the following three terms:

- *Repeatability* (Same team, same experimental setup):
  The measurement can be obtained with stated precision by the same team using the same measurement procedure, the same measuring system, under the same operating conditions, in the same location on multiple trials.
  For computational experiments, this means that a researcher can reliably repeat her own computation.
- *Reproducibility* (Different team, same experimental setup):
  The measurement can be obtained with stated precision by a different team using the same measurement procedure, the same measuring system, under the same operating conditions, in the same or a different location on multiple trials.
  For computational experiments, this means that an independent group can obtain the same result using the author's own artifacts.
- *Replicability* (Different team, different experimental setup):
  The measurement can be obtained with stated precision by a different team, a different measuring system, in a different location on multiple trials.
  For computational experiments, this means that an independent group can obtain the same result using artifacts which they develop completely independently.

These definitions may have been designed for research, but they are valuable also for practical applications.
Regardless whether we want to invent a new algorithm as part of a scientific work or whether we try to solve a very practical problem for a customer, our work should *always be replicable*.
It should be possible that someone else can read our algorithm, implement it by themselves, perform similar experiments, get similar results, and reach the same conclusions as we do.
This may require a lot of work and how exactly this work is done is not in our hands.

#### Basic Advice

We can try to support it by clearly specifying and documenting our algorithm and experiments.
There are several things more that we can do to enable *reproducibility*&nbsp;[@GGM2020GRGFARV1].

1. We state what problem we are trying to solve, what our research objectives are, and which questions we want to answer.
2. We provide the algorithm implementation.
3. We provide the problem instances.
   Sometimes we use public instances that are already available to everyone, as in our JSSP experiment.
   Sometimes we have defined our own instances, which we then should publish.
4. We provide documentation how the algorithm implementation was applied to our problem instances, i.e., how we ran the experiments, how many independent runs we performed per setup, and so on.
   This includes algorithm setup information, random seeds, termination criteria, etc.
5. We provide the results of our experiments in a human-readable form.
   This is especially important when running the experiments is time consuming.
6. We provide the tools we use to "convert" the raw results to the tables and figures we use in our reports.

It is important to always consider reproduciblity *before* running the experiments.
From personal experience, I can say that sometimes, even just two or three years after running the experiments, I have looked at the collected data and did no longer know, e.g., the settings of the algorithms.
Hence, the data became useless.

#### More Detailed Suggestions

Additionally to the points mentioned above, the following measures can be taken to ensure that your experimental results are meaningful to yourself and others in the years to come:

1. Always use self-explaining formats like plain text files to store your results.
   Storing results in some binary format or a database is always the wrong choice.
   If your text-based data is big, you can compress the whole data folders, e.g., using the [`tar`](https://www.gnu.org/software/tar/).[`xz`](https://tukaani.org/xz/) format and the resulting archive will be very small.
2. Create one file for each run of your experiment and *automatically* store at least the following information&nbsp;[@W2017FSDFTSTFOAB; @WCTLTCMY2014BOAAOSFFTTSP] in that file:
   a. the algorithm name and all parameter settings of the algorithm,
   b. the relevant measurements, i.e., the logged data,
   c. the seed of the pseudo-random number generator used,
   d. information about the problem instance on which the algorithm was applied (such as the instance name),
   e. maybe short comments on how the above is to be interpreted,
   f. maybe information about the computer system your code runs on, maybe the Java version, etc., and
   g. maybe even your contact information.
   
   This way, you or someone else can, next year, or in ten years from now, read your results and get a clear understanding of "what is what."
   Ask yourself: If I put my data on my website and someone else downloads it, does every single file contain sufficient information to understand its content?
3. Store the files and the compiled binaries of your code in a self-explaining directory structure&nbsp;[@W2017FSDFTSTFOAB; @WCTLTCMY2014BOAAOSFFTTSP].
   I prefer having a base folder where all the code, results, and evaluation go.
   Into that folder, I like to put a folder `results`.
`results` then contains one folder with a short descriptive name for each algorithm setup, which, in turn, contain one folder with the name of each problem instance.
   The problem instance folders then contain one text file per run.
   This way, it is easy to find all runs for one specific instance, all runs with one specific algorithm, etc.
   After we are done with all experiments and evaluation, such folders lend them self for compression for long-term archiving.
4. Write your experimentation code such that you can specify the random seeds.
   This  allows to easily repeat selected runs or whole experiments.
   All random decisions of an algorithm depend on the random number generator&nbsp;$\random$.
   The "seed" (see *point&nbsp;2.c* above) is an initialization value of&nbsp;$\random$.
   If we initialize the (same) random number generator with the same seed, it will produce the same sequence of random numbers.
   If we know the random seed used for an experiment, then we can start the same algorithm again with the same initialization of the random number generator.
   Then, even if our optimization method is randomized (see [@sec:randomizedAlgos]), it will make the same "random" decisions.
   In other words, we should be able to repeat the experiments and get identical results.
   You can actually do this with the experiments in this book!
   There might be differences if numpy changes the implementation of their [random number generator](https://numpy.org/devdocs/reference/random/generator.html) or if the termination criterion is time-based and a different computer is used.
5. Ensure that all random seeds in the experiments are generated in a deterministic way.    
   The seeds should come from a reproducible sequence, say the same random number generator, but seeded with the MD5 checksum of the instance name.
   This would mean that two algorithms applied to the same instance have the same random seed and may therefore start at the same random point.
6. It is important to clearly document and comment our code.
   In particular, the contracts of each method should be documented such that they can properly be verified in unit tests.
   The unit tests are part of the documentation, too.
7. *All* program code should be designed for being published and useful for others from the very beginning.
   We should prepare it with the same care and diligence that we wish our name to be associated with.
8. The program code for an experiment not just consists of the algorithm implementation, but also the code for running the experiment and the code for evaluating the results, i.e., the code for generating tables and figures. 
9. If we are conducting research work, we should publish all artifacts of our work, all code and data, online:
   a. For code, several free platforms such as [GitHub](http://www.github.com) or [bitbucket](http://bitbucket.org/) exist.
      These platforms often integrate with free continuous integration platforms, which can automatically compile code and run unit tests.
   b. For results, there, too, are free platforms such as [zenodo](http://zenodo.org/).
      Using such online repositories also protects us from losing data.
      This is also a great way to show what you are capable of to potential employers&hellip;
   
   Zenodo has the advantage that it creates immutable archives that guarantee long-term availability.
10. If our code depends on external libraries or frameworks, we should consider using an automated dependency management and build tool.
    For the code associated with this book, I use [pip](https://pypi.org/project/pip/) for dependency management and [make](https://www.gnu.org/software/make/) as build tool.
    If I or someone else wants to use the code later again, the chances are good that the tools can find the same, right versions of all required libraries.

From the above, I think it should have become clear that reproducibility is nothing that we can consider after we have done the experiments.
Hence, like the search for bugs, it is a problem we need to think about beforehand.
Several of the above are basic suggestions which I found useful in my own work.
Some of them are important points that are necessary for good research &ndash; and which sadly are never mentioned in any course.


#### I am Afraid to Publish my Data and Code

Often, researchers are somewhat reluctant to publish their data and code.
They are afraid:
"What if someone finds an error in my work?"
Being blamed that there are problems in the experiments could potentially be dangerous for the career.
I think this is wrong idea for four reasons:

First, if it is very easy to use our code and to replicate our experiments, it becomes more likely that other researchers do exactly this.
They will develop new methods based on ours.
They will compare the performance of their methods with ours.
This will lead to more impact and citations of our work, which is certainly positive.

Second, let's say someone wants to reproduce our results.
The most likely reason for this is that the work is good and interesting and they want to use it.
If they want to use it and they have to implement everything by themselves, then there are two potential sources of problems:

a. Their implementation could be wrong and they may wrongly assume that the error is on our side.
b. They find an error in our work after investing a lot of own work.
   They might incorrectly assume that we intentionally did not provide the data or implementations to make it hard to check our results.

Both of the above may make them think that we committed a misconduct intentionally.
Both scenarios are not good and can be avoided by providing our code and data.

Third, as stated in [@sec:unit_testing_and_analysis], it is very hard to make sure that there are no errors in our experiments.
Errors *will* happen.
If we provide our code and documentation and data, the chances are good that they can be found and fixed.
As researchers, the pursuit of truth and true advance is the goal, so this is what we want.
As application engineers, we want that our systems are correct and work as they should, so this is what we want. 
At least this will avoid any misunderstanding.

Fourth and finally:
Many good journals and conferences now tend to accept only research works that are reproducible and have the code available.
If you want to publish in them, it is best to design the code and experiments for publication from the start. 
