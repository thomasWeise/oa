## Calling Methods and Functions {#sec:pythonCallingMethodsAndFunctions}

In this section, we will learn two simple performance tricks to reduce the overhead of calling methods of objects.
Both tricks are independent and can be used either in combination or separately:

1. Method invocation:
   If a method `meth` of an object `obj` needs to be called often, instead of doing `obj.meth(...)` every time, do `m = obj.meth` and then call `m(...)` instead.
   This saves the time needed to resolve the dot (`.`) for the method call.
2. Method implementation:
   If a method `meth` just and only invokes a function `func`, then instead of implementing `meth` as a method, store a reference to the function in an attribute named `meth`.
   This trick comes especially handy if we use Numba to optimize a function (see [@sec:pythonNumba]).

We will investigate both performance tips, but let us look at the second one first, because it is a bit less intuitive.
Let us imagine that we implement a Python class which has a method `call_function` that will pass its parameters to a library function `my_function`.
`call_function` does nothing else, it will just invoke the library function `my_function` with its own arguments.
How can we do this most efficiently?

At first glance, this is not a real question, because there only is one way to do it:
You implement the method `call_function` using `def` and in its body, we invoke `my_function`.
In this case, any invocation of `call_function` will be a method call and then this method call will perform a function call to `my_function`.
This standard approach is illustrated as class `MethodCall` and in function `method_call` in [@lst:callingMethodsAndFunctions].

Interestingly, there is a second option here:
Instead of implementing `call_function` as a method, we could create a member variable `call_function` inside the `__init(self)__` constructor and let this variable point to `my_function`.
This variable will still be `callable`, exactly as `call_function`.
However, if we now invoke `call_function`, this will already be the function call to `my_function` and we save one method call.
In [@lst:callingMethodsAndFunctions], we implement this somewhat dodgy idea in class `FunctionAsAttribute` and function `function_attribute`.
 
In a situation where we want to invoke `call_function` many times, it makes sense to store a reference to it in a local variable&nbsp;`m`.
The reason is that every time a dot (`.`) is resolved, it costs some time.
For example, if we implement an optimization algorithm that needs to generate many random numbers by often calling the `random.integer(...)` of the random number generator `random`, it makes sense to store `m = random.integers` and then call `m(...)` instead.
This situation is shown as method `direct` (using again class `FunctionAsAttribute`) in [@lst:callingMethodsAndFunctions].

\rel.code{callingMethodsAndFunctions}{Different ways to realize an object calling a function.}{callingMethodsAndFunctions.py}{}{}{}

|what|measured time|
|--:|--:|
|method call|0.9173|
|function attribute|0.6086|
|direct invocation|0.4434|

: The output of [@lst:callingMethodsAndFunctions]. {#tbl:callingMethodsAndFunctionsResults}

The results of executing the program are shown in [@tbl:callingMethodsAndFunctionsResults].
We find that storing a function reference as attribute instead of calling the function from a method can save about one third of the function invocation overhead.
The function needs to be called many times in a loop, another 25% of overhead can be cut by storing a reference to it in a local variable instead of accessing it via the object.
Therefore, we have confirmed the two simple tricks to improve performance of method or function calls.
Remember, both tricks are independent of each other and can be used separately.

In [@sec:structure], we dissected the structure of optimization problems.
We defined base classes for implementing spaces of solutions, objective functions, search operators, and so on.
In our concrete example for the Job Shop Scheduling Problem, we defined a the search space as the space of permutations with repetitions.
We implemented such permutations as [numpy integer array](https://numpy.org/doc/stable/user/basics.types.html) in [@sec:jsspSearchSpace].
Similarly, we defined Gantt charts as three-dimensional numpy integer arrays in [@sec:jssp:gantt].

Now our API for search and solution spaces (see [@lst:Space]) demands that we tell the system how to copy on element to another.
This corresponds in both of the above cases to calling `np.copy_to`.
It is exactly an example of this "paradigm" discussed here:
We can implement this as a method call that calls the library function.
Or we can let a member variable point to the library function directly, saving one method call.
We choose the latter approach as illustrated, e.g., in [@lst:jssp_gantt_space].
