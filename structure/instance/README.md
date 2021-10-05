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
In the a basic and yet general scenario&nbsp;[@GLLRK1979OAAIDSASAS; @LLRKS1993SASAAC; @L1982RRITTOMS; @T199BFBSP], our factory has&nbsp;$\jsspMachines\in\naturalNumbersO$ machines.^[where&nbsp;$\naturalNumbersO$ stands for the natural numbers greater than&nbsp;0, i.e., 1, 2, 3, &hellip;]
At each point in time, a machine can either work on exactly one job or do nothing (be idle).
A job may correspond to a customer order, e.g., "produce 10 red lady's sneakers."
There are&nbsp;$\jsspJobs\in\naturalNumbersO$ jobs that we need to schedule to these machines.
For the sake of simplicity and for agreement between our notation here, the Python source code, and the example instances that we will use, we reference jobs and machines with zero-based indices from&nbsp;$0\dots(\jsspJobs-1)$ and&nbsp;$0\dots(\jsspMachines-1)$, respectively.

Each of the&nbsp;$\jsspJobs$ jobs is composed of&nbsp;$\jsspMachines$ "operations" &ndash; one for each machine.
These operations correspond to the single production steps, such as "cut the cloth material," "stitch the cloth material to the sole," and so on.
Each job may need to pass through the machines in a different order.
The operation&nbsp;$\jsspMachineIndex$ of job&nbsp;$\jsspJobIndex$ must be executed on machine&nbsp;$\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}\in 0\dots(\jsspMachines-1)$.
Doing so needs&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}\in\naturalNumbersZ$ time units for completion.
Once a machine begins to process an operation, it cannot stop until&nbsp;$\jsspMachineIndex$ the operation is completed, i.e., will remain busy for&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}\in\naturalNumbersZ$ time units.

This definition may seem a bit strange at first, but upon closer inspection is quite versatile.
Assume that we have a factory that produces exactly one product, but different customers may order different quantities.
Here, we would have JSSP instances where all jobs need to be processed by exactly the same machines in exactly the same sequence.
In this case&nbsp;$\jsspOperationMachine{\jsspJobIndex_1}{\jsspMachineIndex}=\jsspOperationMachine{\jsspJobIndex_2}{\jsspMachineIndex}$ would hold for all jobs&nbsp;$\jsspJobIndex_1$ and&nbsp;$\jsspJobIndex_2$ and all operation indices&nbsp;$\jsspMachineIndex$.
The jobs would pass through all machines in the same order but may have different processing times (due to the different quantities).

We may also have scenarios where customers can order different types of products, say the same liquid soap, but either in bottles, plastic bags, or big cannisters.
Then, different machines may be needed for different orders.
This is similar to the situation illustrated in [@fig:jssp_sketch], where a certain job&nbsp;$\jsspJobIndex$ does not need to be executed on a machine&nbsp;$\jsspMachineIndex'$.
We then can simply set the required time&nbsp;$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}$ to&nbsp;0 for the operation&nbsp;$\jsspMachineIndex$ with&nbsp;$\jsspOperationMachine{\jsspJobIndex}{\jsspMachineIndex}=\jsspMachineIndex'$.
Notice that for this reason we wrote "$\jsspOperationTime{\jsspJobIndex}{\jsspMachineIndex}\in\naturalNumbersZ$" above, where $\naturalNumbersZ$ refers to 0, 1, 2, &hellip;  

In other words, the JSSP instance structure described here already encompasses a wide variety of real-world production situations.
This means that if we can build an algorithm which can solve this general type of JSSP well, it can also automatically solve the above-mentioned special cases.

#### Sources for JSSP Instances
