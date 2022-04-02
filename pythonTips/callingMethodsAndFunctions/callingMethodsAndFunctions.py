from timeit import timeit

def my_function():  # the function to be called
    pass            # does nothing

class MethodCall:             # the "normal" way to call a function:
    def call_function(self):  # define method that calls function
        my_function()         # call the function

class FunctionAsAttribute:    # set a callable attribute instead
    def __init__(self):       # this is done in the constructor
        self.call_function = my_function

def method_call():  # test the "normal" method
    c = MethodCall()
    for i in range(100000):
        c.call_function()  # call method which then calls function

def function_attribute():  # test setting a "callable" attribute
    c = FunctionAsAttribute()
    for i in range(100000):
        c.call_function()  # call function directly

def direct():  # save dot resolution: put funtion ref in local variable
    c = FunctionAsAttribute()
    m = c.call_function  # shovel function ref into local variable
    for i in range(100000):
        m()  # call function via local variable

print(f"       method call: {timeit(method_call,        number=100)}")
print(f"function attribute: {timeit(function_attribute, number=100)}")
print(f" direct invocation: {timeit(direct,             number=100)}")
