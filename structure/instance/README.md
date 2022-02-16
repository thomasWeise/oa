## Problem Instance Data {#sec:problemInstance}

### Definitions

We distinguish optimization *problems* (see \def.ref{optimizationProblemMathematical}) from *problem instances*.
An optimization problem is the general blueprint of the tasks.
The JSSP (see [@sec:jsspExample]), for instance, has the goal of scheduling production jobs to machines under a set of constraints that we will discuss later.
A problem instance of the JSSP is a concrete scenario, e.g., a concrete lists of tasks, requirements, and machines.

\definition{def}{instance}{A concrete instantiation of all information that are relevant from the perspective of solving an optimization problems is called a *problem instance*&nbsp;$\instance$.}

The problem instance is the input of the optimization algorithms.
A problem instance is related to an optimization problem in the same way an object/instance is related to its `class` in an object-oriented programming language like Python or Java, or a `struct` in&nbsp;C.
The `class` defines which member variables exists and what their valid ranges are.
An instance of the class is a piece of memory which holds concrete values for each member variable.


### Example: Job Shop Scheduling {#sec:jsspInstance}

#### JSSP Instance Structure

So how can we characterize a JSSP instance&nbsp;$\instance$?
In the basic and yet general scenario&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS; @T199BFBSP], our factory has&nbsp;$\jsspMachines\in\naturalNumbersO$ machines.^[where&nbsp;$\naturalNumbersO$ stands for the natural numbers greater than&nbsp;0, i.e., 1, 2, 3, &hellip;]
At each point in time, a machine can either work on exactly one job or do nothing (be idle).
A job may correspond to a customer order, e.g., "produce 10 red lady's sneakers."
There are&nbsp;$\jsspJobs\in\naturalNumbersO$ jobs that we need to schedule to these machines.
For the sake of simplicity and for agreement between our notation here, the Python source code, and the example instances that we will use, we reference jobs and machines with zero-based indices from&nbsp;$\intRange{0}{(\jsspJobs-1)}$ and&nbsp;$\intRange{0}{(\jsspMachines-1)}$, respectively.

Each of the&nbsp;$\jsspJobs$ jobs is composed of&nbsp;$\jsspMachines$ "operations" &ndash; one for each machine.
These operations correspond to the single production steps, such as "cut the cloth material," "stitch the cloth material to the sole," and so on.
Each job may need to pass through the machines in a different order.
The operation&nbsp;$\jsspMachineIndex$ of job&nbsp;$\jsspJobIndex$ must be executed on machine&nbsp;$\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}\in \intRange{0}{(\jsspMachines-1)}$.
Doing so needs&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}\in\naturalNumbersZ$ time units for completion.
Once a machine&nbsp;$\jsspMachineIndex$ begins to process an operation, it cannot stop until the operation is completed, i.e., will remain busy for&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}\in\naturalNumbersZ$ time units.

This definition may seem a bit strange at first, but upon closer inspection is quite versatile.
Assume that we have a factory that produces exactly one product, but different customers may order different quantities.
Here, we would have JSSP instances where all jobs need to be processed by exactly the same machines in exactly the same sequence.
In this case&nbsp;$\jsspOperationMachine{\jsspJobIndex_1}{\jsspMachineIndex}=\jsspOperationMachine{\jsspJobIndex_2}{\jsspMachineIndex}$ would hold for all jobs&nbsp;$\jsspJobIndex_1$ and&nbsp;$\jsspJobIndex_2$ and all operation indices&nbsp;$\jsspMachineIndex$.
The jobs would pass through all machines in the same order but may have different processing times (due to the different quantities).

We may also have scenarios where customers can order different types of products, say the same liquid soap, but either in bottles, plastic bags, or big cannisters.
Then, different machines may be needed for different orders.
This is similar to the situation illustrated in [@fig:jssp_sketch], where some job&nbsp;$\jsspJobIndex$ does not need to be executed on a machine&nbsp;$\jsspMachineIndex'$.
We then can simply set the required time&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}$ to&nbsp;0 for the operation&nbsp;$\jsspMachineIndex$ with&nbsp;$\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}=\jsspMachineIndex'$.
Notice that for this reason we wrote "$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}\in\naturalNumbersZ$" above, where $\naturalNumbersZ$ refers to 0, 1, 2, &hellip;  

In other words, the JSSP instance structure described here already encompasses a wide variety of real-world production situations.
This means that if we can build an algorithm which can solve this general type of JSSP well, it can also automatically solve the above-mentioned special cases.


#### JSSP Benchmark Instances

In order to practically play around with optimization algorithms, we need some concrete instances of the JSSP.
Luckily, the optimization community provides "benchmark instances" for many different optimization problems.
Such common, well-known instances are important, because they allow researchers to compare their algorithms.

The eight classical and most commonly used sets of benchmark instances for the JSSP&nbsp;[@H2002PJSSP] are published in&nbsp;[@FT1963PLCOLJSSR; @ABZ1988TSBPFJSS; @AC1991ACSOTJSSP; @SWV1992NSSFSPWATJSS; @YN1992AGAATLSJSI; @L1998RCPSAEIOHSTS; @DMU1998BFSSP; @T199BFBSP].
Their data can be found (sometimes partially) in several repositories in the Internet, such as

- the [*OR&#8209;Library*](http://people.brunel.ac.uk/~mastjjb/jeb/orlib/jobshopinfo.html) managed by Beasley&nbsp;[@B1990OLDTPBEM],
- the comprehensive [set of JSSP instances](http://jobshop.jjvh.nl/) provided by van&nbsp;Hoorn&nbsp;[@vH2015JSIAS; @vH2018TCSOBOBIOTJSSP], where also state-of-the-art results are listed,
- [Oleg Shylo's Page](http://optimizizer.com/jobshop.php)&nbsp;[@S2019JSSPH], which, too, contains up-to-date experimental results,
- [Éric Taillard's Page](http://mistic.heig-vd.ch/taillard/problemes.dir/ordonnancement.dir/ordonnancement.html), or, finally,
- my own repository [jsspInstancesAndResults](http://github.com/thomasWeise/jsspInstancesAndResults)&nbsp;[@W2019JRDAIOTJSSP], where I collect all the above problem instances and many results from existing works.

We will try to solve JSSP instances obtained from these collections.
The goal of this book is that you can play around with the algorithms and replicate our experiments.
Therefore, we cannot use all 242&nbsp;instances from the above sets, because then the experiments would take too long.
We have to pick a small representative subset of instances.
We therefore first removed 67&nbsp;instances that are relatively easy from the instance set and then tried pick problems with different scales and from different sources.  
They will serve as illustrative example of how to approach optimization problems.
In order to keep the example and analysis simple, we will focus on only eight instances, namely

1. Instance `abz8` by Adams et&nbsp;al.&nbsp;[@ABZ1988TSBPFJSS] has 20&nbsp;jobs and 15&nbsp;machines.
   The processing times of its operations were chosen from the interval&nbsp;\intRange{11}{40}.
2. Instance `dmu67` by Demirkol et&nbsp;al.&nbsp;[@DMU1998BFSSP] has 40&nbsp;jobs and 20&nbsp;machines.
   Its processing times were chosen from the interval&nbsp;\intRange{1}{200}.
   This instance is structured such that the jobs first need to pass one (randomly chosen) half of the machines and then the other.
3. Instance `dmu72` from the same group has the same structure as `dmu67`, but 50&nbsp;jobs and 15&nbsp;machines.
4. Instance `la38` by Lawrence&nbsp;[@L1998RCPSAEIOHSTS] has 15&nbsp;jobs and 15&nbsp;machines.
   Its processing times are from&nbsp;\intRange{5}{99}.
5. Instance `orb06` by Applegate and Cook&nbsp;[@AC1991ACSOTJSSP] has 10&nbsp;jobs and 10&nbsp;machines.
   It was generated in 1986 as part of a set of "specially generated tougher problems"&nbsp;[@JM1999DJSSPPAF; @H2002PJSSP].
   Nevertheless, it will be the smallest instance in our experiments.
6. Instance `swv14` by Storer et&nbsp;al.&nbsp;[@SWV1992NSSFSPWATJSS] has 50&nbsp;jobs and 10&nbsp;machines.
   Its processing times are from the interval&nbsp;\intRange{1}{100}.
   Like in the case of `dmu72`, the jobs first need to pass one (randomly chosen) half of the machines and then the other.
7. Instance `ta70` by Taillard&nbsp;[@T199BFBSP] has 50&nbsp;jobs and 20&nbsp;machines.
   Its processing times are from the interval&nbsp;\intRange{1}{99}.
8. Instance `yn4` by Yamada and Nakano&nbsp;[@YN1992AGAATLSJSI] has 20&nbsp;jobs and 20&nbsp;machines.
   Its processing times are from the interval&nbsp;\intRange{10}{50}.

The raw data of these instances is part of the [`moptipy`](\repo{mp}{repo.url}) Python package with the sources for our experiments as resource <\repo{mp}{repo.url}/blob/main/moptipy/examples/jssp/instances.txt>.

Of course, if we really want to solve a new type of problem, we will normally use many benchmark problem instances to get a good understand about the performance of our algorithm(s).
Only for the sake of clarity of presentation, we will here limit ourselves to these above eight problems.
We have chosen them as hopefully diverse representatives of all of the common JSSP benchmarks.
They stem from instance sets contributed by different researchers and have different numbers of jobs and machines.


#### File Format and `demo` Instance {#sec:jsspDemoInstance}

For the sake of simplicity, we created one additional, smaller JSSP instance to describe the format of these files, as illustrated in [@fig:jssp_demo_instance].
This instance will also allow us to describe components of optimization processes in an easy way.

\rel.figure{jssp_demo_instance}{The meaning of the text representing our `demo` instance of the JSSP, as an example of the format used in the OR&#8209;Library.}{demo_instance.svgz}{width=90%}

In the simple text format used in OR&#8209;Library, several problem instances can be contained in one file.
Each problem instance&nbsp;$\instance$ starts and ends with a line of several `+` characters.
The next line is a short description or title of the instance.
In the third line, the number&nbsp;$\jsspJobs$ of jobs is specified, followed by the number&nbsp;$\jsspMachines$ of machines.
The actual IDs or indexes of machines and jobs are 0-based, similar to array indices in Python.
The JSSP instance definition is completed by&nbsp;$\jsspJobs$ lines of text, each of which specifying the operations of one job&nbsp;$\jsspJobIndex\in\intRange{0}{(\jsspJobs-1)}$.
Each operation&nbsp;$\jsspMachineIndex$ is specified as a pair of two numbers, the ID&nbsp;$\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}$ of the machine that is to be used (violet), from the interval&nbsp;$\intRange{0}{(\jsspMachines-1)}$, followed by the number of time units&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}$ the job will take on that machine.
The order of the operations defines exactly the order in which the job needs to be passed through the machines.
Of course, each machine can only process at most one job at a time.

In our demo instance illustrated in [@fig:jssp_demo_instance], this means that we have&nbsp;$\jsspJobs=4$ jobs and&nbsp;$\jsspMachines=5$ machines.
Job&nbsp;0 first needs to be processed by machine&nbsp;0 for 10&nbsp;time units, it then goes to machine&nbsp;1 for 20&nbsp;time units, then to machine&nbsp;2 for 20&nbsp;time units, then to machine&nbsp;3 for 40&nbsp;time units, and finally to machine&nbsp;4 for 10&nbsp;time units.
This job will thus take at least&nbsp;100 time units to be completed, if it can be scheduled without any delay or waiting period, i.e., if all of its operations can directly be processed by their corresponding machines.
Job&nbsp;3 first needs to be processed by machine&nbsp;4 for 50&nbsp;time units, then by machine&nbsp;3 for 30&nbsp;time units, then by machine&nbsp;2 for 15&nbsp;time units, then by machine&nbsp;0 for&nbsp;20 time units, and finally by machine&nbsp;1 for 15&nbsp;time units.
It would not be allowed to first send Job&nbsp;3 to any machine different from machine&nbsp;4 and after being processed by machine&nbsp;4, it must be processed by machine&nbsp;3 &ndash; although it may be possible that it has to wait for some time, if machine&nbsp;3 would already be busy processing another job.
In the ideal case, job&nbsp;3 could be completed after 130&nbsp;time units.


#### A Python Class for JSSP Instances

This structure of a JSSP instance can be represented by the simple Python class.
In [@lst:jssp_instance], we give an excerpt of this class, i.e., a snippet of the original code where some methods and data verification has been omitted.
Each instance has a `name`, a number&nbsp;$\jsspJobs$ of jobs stored in the variable `jobs`, and a number&nbsp;$\jsspMachines$ machines stored in the variable `machines`.
We derive our class from [`numpy.ndarray`](https://numpy.org/doc/stable/reference/generated/numpy.ndarray.html), so that it can represent the data directly.
While the text file format displayed in [@fig:jssp_demo_instance] lists the data in two dimensions, we choose to use three:
Each `Instance` is an array with one row for each job, one column for each operation, and each cell holds two values with the machine and the time spent on the machine.
In other words, an $\instance[\jsspJobIndex, \jsspMachineIndex, 0]$ holds the machine&nbsp;$\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}$ for the operation&nbsp;$\jsspMachineIndex$ of job&nbsp;$\jsspJobIndex$. 
$\instance[\jsspJobIndex, \jsspMachineIndex, 1]$ holds the time&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}$ that job&nbsp;$\jsspJobIndex$ will spend on machine&nbsp;$k$.

\git.code{mp}{jssp_instance}{Excerpt from a Python class for representing the data of a JSSP instance.}{moptipy/examples/jssp/instance.py}{}{book}{doc,hints,comments}

We add a static method `from_resource(name)` to this class that can load any of the aforementioned benchmark JSSP instances directly based on its name.
This way, we can conveniently access all the necessary data of a job shop scheduling task.
The actual code of the above, other utility methods, as well as sanity checks in the `__new__` constructor have here been omitted as they are unimportant for the understanding of the scenario.
