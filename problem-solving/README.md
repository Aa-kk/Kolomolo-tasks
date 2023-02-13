# Solution To Basic Knowledge Questions and The Problem_Solving Task
In this folder you would find anwers to to the Basic Knowlodge questions, and the file containing the debugged code for the Problem solving task.



## Answers to the Basic knowlegde questions
1. `__main__.py` is a special Python file that is used to note the default entry point for a Python module. When you run a Python script, the Python interpreter will first look for a file named `__main__.py` in the current directory. If it finds one, it will execute the code contained in that file. When you use `__main__.py`, you can control which code gets executed when the module is run, rather than relying on the name of the file or the directory.

2. If you want to prevent code in a Python module from executing when it's imported, you can wrap the code in a function or a conditional statement. When we wrap it into a function and use the if "`__name__ == __main__`" block to trigger the function to run, the code would only run when the module is called as a script and not imported, because that's when `__name__` would be equal to `__main__`.

3. The `__init__.()` method is class constructor for python.

4. To insert the value of a variable in a string you can do:
    * Use the f-string 
    * Using str.format() method
    * Using the % operator

5. To restrict access to a private method you can use the "__" prefix before the name of the method.
This doesn't truly restrict access to the method though because you can still call the method from outside the class by using the '_class-name__private-method-name' naming convention.

6. to add some functionalities to an existing function without interfering into its code, you make use of a decorator which is  a special type of function that takes another function as input, adds some additional behavior to it, and returns a new function that combines the behavior of both functions. the decorator function can be called through the `@decorator_function` syntax just before the other function or using the `decorator_function(other_function)`.

7. `@staticmethod` is used to define a static method that does not receive any arguments that refer to the instance of the class or the class itself, while `@classmethod` is used to define a class method that receives the class itself as its first argument.

8. Using `with` means that the file will be closed as soon as you leave the block. This is beneficial because closing a file is something that can easily be forgotten and ties up resources that you no longer need.



# Issues with the Problem_solving code 
1. First we had a syntax error on line 17 we had the "==" which is a python operator for comparison ie (If a == b) and we used it to assign a the age object to the class. 

2. Secondly on line 18 we had a type error for "self.increase_count()" because you forgot to specify the self argument in the definition of the increase_count class method.

3. On line 45 we have another syntax error as it is supposed to be `__main__` and not `main`.

4. On line 32 the order in which the class properties were being assigned in line 14 was not followed.

