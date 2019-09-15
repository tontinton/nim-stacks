## Pure Nim stack implementation based on sequences.
##
## * [Repo](https://github.com/rustomax/nim-stacks)
## * [Docs](https://rustomax.github.io/dev/nim/stacks/stacks.html)
##
## **Example:**
##
## .. code-block:: Nim
##   # Reverting a string using a stack
##
##   let a = "Hello, World!"
##   var s = Stack[char]()
##   for letter in a:
##       s.push(letter)
##
##   var b: string
##   while not s.empty:
##       b.add(s.pop)
##
##   assert b == "!dlroW ,olleH"
##

import math

type EStackEmpty* = object of Exception

type
    Stack* [T] = object
        data: seq[T]

proc newStack* [T](capacity = 8): Stack[T] =
    ## Creates a new stack.
    ## Optionally, the initial capacity can be reserved via `capacity` parameter.
    ##
    ## .. code-block:: Nim
    ##   var a = newStack[int](capacity = 64)
    assert isPowerOfTwo(capacity)
    result.data = newSeqOfCap[T](capacity)

proc len* [T](s: Stack[T]): int =
    ## Returns the number of elements in the stack.
    ## Returns `0` if the stack is empty.
    ##
    ## .. code-block:: Nim
    ##   var a = newStack[int]()
    ##   assert a.len == 0
    ##   a.push(10); a.push(20)
    ##   assert a.len == 2
    s.data.len()

proc empty* [T](s: Stack[T]): bool =
    ## Returns `true` if stack contains no elements, `false` otherwise.
    ##
    ## .. code-block:: Nim
    ##   var a = newStack[int]()
    ##   assert a.empty == true
    ##   a.push(10)
    ##   assert a.empty == false
    s.data.len() == 0

proc push* [T](s: var Stack[T], element: T) =
    ## Pushes `element` onto the top of the stack.
    ##
    ## .. code-block:: Nim
    ##   var a = newStack[int]()
    ##   a.push(10)
    s.data.add(element)

proc pop* [T](s: var Stack[T]): T {.raises: [EStackEmpty].} =
    ## Pops the top element from the stack.
    ## Raises `EStackEmpty` exception if the stack is empty.
    ##
    ## .. code-block:: Nim
    ##   var a = newStack[int]()
    ##   a.push(10)
    ##   discard a.pop()
    ##   doAssertRaises(EStackEmpty, echo a.pop())
    if not s.empty:
        result = s.data[^1]
        s.data.setLen s.data.len - 1
    else:
        raise newException(EStackEmpty, "Cannot pop an empty stack")

proc clear* [T](s: var Stack[T]) =
    ## Empties the stack. Does nothing if the stack is already empty.
    ##
    ## .. code-block:: Nim
    ##   var a = newStack[int]()
    ##   assert a.empty == true
    if not s.empty:
        s.data.setLen 0

proc toSeq* [T](s: Stack[T]): seq[T] =
    ## Returns sequence representation of a stack.
    ##
    ## .. code-block:: Nim
    ##   var a = newStack[int]()
    ##   a.push(10); a.push(20)
    ##   assert a.toSeq() == @[10, 20]
    s.data

proc `$`* [T](s: Stack[T]): string =
    ## Returns string representation of a stack
    ##
    ## .. code-block:: Nim
    ##   var a = newStack[int]()
    ##   a.push(10); a.push(20)
    ##   assert $a == "Stack[10, 20]"
    result = "Stack["
    if not s.empty():
        for i in 0 .. s.data.high() - 1:
            result &= $s.data[i]
            result &= ", "
        result &= $s.data[^1]
    result &= "]"

when isMainModule:
    block:
        var a = newStack[int]()
        a.push(10)
        assert a.empty == false
        discard a.pop()
        assert a.empty == true

    block:
        var a = newStack[int]()
        a.push(10)

    block:
        var a = newStack[int]()
        a.push(10); a.push(20)
        assert $a == "Stack[10, 20]"

    block:
        var a = newStack[int]()
        a.push(10); a.push(20)
        assert a.len == 2

    block:
        var a = newStack[int]()
        a.push(10)
        discard a.pop()
        doAssertRaises(EStackEmpty, echo a.pop())