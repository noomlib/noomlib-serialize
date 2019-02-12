import pairs, next, tostring from _G
import floor from math
import byte, format, gsub from string
import sort from table

import MAP_PRIMITIVES_WEIGHTS, STRINGS_PATTERN_CONTROL, STRINGS_WRITE_ESCAPE from "noomlib/serialize/json/constants"

-- string escape_char(string char)
-- Returns an escaped character valid for JSON
escape_char = (char) ->
  return STRINGS_WRITE_ESCAPE[char] or format(STRINGS_PATTERN_UNICODE, byte(char))

-- string escape_string(string string)
-- Returns an escaped string valid for JSON
escape_string = (string) ->
    return gsub(string, STRINGS_PATTERN_CONTROL, escape_char)

-- string escape_boolean(boolean value)
-- Returns a boolean encoded as a string for JSON
export encode_boolean = (value) ->
    return tostring(value)

-- string encode_float(number value)
-- Encodes a number as a float for JSON
export encode_float = (value) ->
    unless is_number_valid(value) then error("bad argument #1 to 'encode_float' (expected rational number)")

    return floor(value) == value and format("%.1f", value) or format("%.14g", value)

-- string encode_integer(number value)
-- Encodes a number as an integer for JSON
export encode_integer = (value) ->
    unless is_number_valid(value) then error("bad argument #1 to 'encode_integer' (expected rational number)")

    return format("%d", value)

-- string encode_string(string value)
-- Encodes a string as a delimited string for JSON
export encode_string = (value, delimit) ->
    string = escape_string(value)

    return delimit .. string .. delimit

-- table[] get_sorted_map(table value)
-- Returns a table of `{key = string, value = any}` values, sorted by `key` and type primitives
export get_sorted_map = (value) ->
    map = [{:key, :value} for key, value in pairs(value)]

    sort(map, (a, b) -> a.key >= b.key)
    sort(map, (a, b) ->
        a_weight = MAP_PRIMITIVES_WEIGHTS[type(a.value)]
        b_weight = MAP_PRIMITIVES_WEIGHTS[type(b.value)]

        if a_weight < b_weight then return true
        return false
    )

    return map

-- boolean is_array(table value)
-- Returns if the table is an array
export is_array = (value) ->
    return value[1] ~= nil or next(value) == nil

-- boolean is_array_sparse(table value)
-- Returns if the table is a sparse array
export is_array_sparse = (value) ->
    previous = 0

    for index, _ in pairs(value)
        if type(index) ~= "number" return true
        if (index - previous) ~= 1 then return true

        previous = index

    return false

-- number is_number_valid(number value)
-- Returns if the number is valid for JSON, e.g. NaN, -inf, inf
export is_number_valid = (value) ->
    return value == value and
        value >= -math.huge and
        value <= math.huge