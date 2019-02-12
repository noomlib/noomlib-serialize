-- number INDENTATION_DEFAULT_SCOPE
-- Represents the default indentation scope
export INDENTATION_DEFAULT_SCOPE = 0

-- string INDENTATION_DEFAULT_STRING
-- Represents the default indentation character sequence
export INDENTATION_DEFAULT_STRING = "\t"

-- table<string, number> MAP_PRIMITIVES_WEIGHTS
-- Represents the weights of Lua primitive types, for sorting
export MAP_PRIMITIVES_WEIGHTS = {
    "nil": 0,
    "boolean": 1,
    "number": 2,
    "string": 3,
    "table": 4
}

-- string NEWLINE_DEFAULT_DELIMIT
-- Represents the default newline character sequence
export NEWLINE_DEFAULT_STRING = "\n"

-- string SYMBOL_ARRAY_END
-- Represents the symbol used for ending an array
export SYMBOL_ARRAY_END = "]"

-- string SYMBOL_ARRAY_START
-- Represents the symbol used for starting an array
export SYMBOL_ARRAY_START = "["

-- string SYMBOL_PROPERTY_ASSIGN
-- Represents the symbol character sequence used for assigning a property name
export SYMBOL_PROPERTY_ASSIGN = ":"

-- string SYMBOL_PROPERTY_DELIMT
-- Represents the symbol used to delimit properites
export SYMBOL_PROPERTY_DELIMIT = ","

-- string SYMBOL_MAP_END
-- Represents the symbol used for ending a map
export SYMBOL_MAP_END = "}"

-- string SYMBOL_MAP_START
-- Represents the symbol used for starting a map
export SYMBOL_MAP_START = "{"

-- string SYMBOL_STRING_DOUBLE
-- Represents one of the symbols used for delimiting a string
export SYMBOL_STRING_DOUBLE = '"'

-- string SYMBOL_STRING_SINGLE
-- Represents one of the symbols used for delimiting a string
export SYMBOL_STRING_SINGLE = "'"

-- string STRINGS_PATTERN_CONTROL
-- Represents a Lua pattern to capture control codes
export STRINGS_PATTERN_CONTROL = '[%z\1-\31\\"]'

-- string STRINGS_PATTERN_UNICODE
-- Represents a Lua pattern to capture unicode
export STRINGS_PATTERN_UNICODE = "\\u%04x"

-- table<string, string> STRINGS_WRITE_ESCAPE
-- Represents the string escape map of used for writing JSON
export STRINGS_WRITE_ESCAPE = {
    "\\": "\\\\",
    "\"": "\\\"",
    "\b": "\\b",
    "\f": "\\f",
    "\n": "\\n",
    "\r": "\\r",
    "\t": "\\t"
}

-- table<string, string> STRINGS_READ_ESCAPE
-- Represents the string escape map used for reading JSON
export STRINGS_READ_ESCAPE = do
    escape_map = {key, value for key, value in pairs(STRINGS_WRITE_ESCAPE)}
    escape_map["\\/"] = "/"

    return escape_map