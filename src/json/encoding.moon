import pairs, type from _G
import floor from math

import BufferWriter from "noomlib/io/buffer/buffer-writer"

import 
    INDENTATION_DEFAULT_SCOPE,
    INDENTATION_DEFAULT_STRING,
    NEWLINE_DEFAULT_STRING,
    SYMBOL_ARRAY_END,
    SYMBOL_ARRAY_START,
    SYMBOL_PROPERTY_ASSIGN,
    SYMBOL_PROPERTY_DELIMIT,
    SYMBOL_MAP_END,
    SYMBOL_MAP_START,
    SYMBOL_STRING_DOUBLE
from "noomlib/serialize/json/constants"

import JSONWriter from "noomlib/serialize/json/json-writer"
import get_sorted_map, is_array, is_array_sparse from "noomlib/serialize/json/utilities"

-- JSONEncodeOptions JSONEncodeOptions(table [options])
-- Represents the options used for
export JSONEncodeOptions = (options = {}) ->
    unless type(options) == "table" then error("bad argument #1 to 'JSONEncodeOptions' (expected table)")

    return {
        -- string JSONEncodeOptions::indentation
        -- Represents the character sequence used for scope-based indentation
        indentation: options.indentation == nil and INDENTATION_DEFAULT_STRING or options.indentation,

        -- boolean JSONEncodeOptions::in_property
        -- Represents if the JSONWriter is currently writting for a property name
        in_property: options.in_property or false,

        -- boolean JSONEncodeOptions::has_sibling
        -- Represents if JSONWriter just previously wrote a sibling property
        has_sibling: options.has_sibling or false,

        -- boolean JSONEncodeOptions::maps_sorted
        -- Represents if maps are sorted by key
        maps_sorted: options.maps_sorted or false,

        -- string JSONEncodeOptions::newline
        -- Represents the character sequence used for newlines
        newline: options.newline == nil and NEWLINE_DEFAULT_STRING or options.newline,

        -- string JSONEncodeOptions::quote
        -- Represents the quote delimiter for strings
        quote: options.quote == nil and SYMBOL_STRING_DOUBLE or options.quote,

        -- number JSONEncodeOptions::scope
        -- Represents the current indentation scope
        scope: options.scope or INDENTATION_DEFAULT_SCOPE

        -- number JSONEncodeOptions::size
        -- Represents the amount of bytes to allocate to a buffer, if no buffer is provided
        size: options.size or 0
    }

export decode = (value) ->

-- BufferWriter or string encode(any value, JSONEncodeOptions [options], BufferWriter [buffer])
-- Encodes the value into JSON into the given buffer, and returns the buffer.
-- If no Buffer is given, it uses `BufferWriter` from `noomlib/io` and returns a string
export encode = (value, options = JSONEncodeOptions(), buffer = nil) ->
    has_buffer = buffer and true or false
    unless buffer then buffer = BufferWriter(options.size)

    cache = {}
    writer = JSONWriter(buffer, options)

    local self
    self = {
        boolean: writer.write_boolean,
        string: writer.write_string,

        any: (value) ->
            func = self[type(value)]
            unless func then error("bad argument #1 to 'encode.any' (expected primitive values in table)")

            func(value)

        number: (value) ->
            if floor(value) == value then writer.write_integer(value)
            else writer.write_float(value)

        "nil": (value) ->
            writer.write_raw("null")

        table: (value) ->
            if is_array(value) then
                if is_array_sparse(value) then error("bad argument #1 to 'encode.table' (expected non-sparse array)")

                writer.write_array_start()

                for property in *value
                    self.any(property)

                writer.write_array_end()

            else
                writer.write_map_start()

                if options.maps_sorted
                    value = get_sorted_map(value)

                    for property in *value
                        if type(property.key) ~= "string" then error("bad argument #1 to 'encode.table' (expected key strings)")

                        writer.write_property(property.key)
                        self.any(property.value)

                else
                    for key, property in pairs(value)
                        if type(key) ~= "string" then error("bad argument #1 to 'encode.table' (expected key strings)")

                        writer.write_property(key)
                        self.any(property)

                writer.write_map_end()
    }

    self.any(value)

    if has_buffer then return buffer
    else return buffer.get_buffer_string(false)