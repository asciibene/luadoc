# LuaDoc

LuaDoc is a simple lua script that generates useful HTML documentation by parsing specially formated comments in your Lua code files.

**TODO:**
- Documentation of objects (i.e. Dicts)
- Better pattern matching (still no regex)

## Markup to use in your code

The following have to be carefully respected.

### Documenting functions

You can provide a short description of any function in your code.
Also available is description of function's arguments/parameters.

Here is an example:
```
--> This lua comment is the function short description.
function generic_function(x)
    -- [x]: description of argument named "x"
    return x + x
end
```

So in simple words, to create a function description insert a comment **before** the function definition, and make sure to start the comment with `-->` followed by a single space.
As for arguments description you simply need to have the name of it in-between square brackets followed by a colon.
`-- [arg]: argument description!`
