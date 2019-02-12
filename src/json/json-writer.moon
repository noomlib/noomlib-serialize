import tostring, type from _G
import match, rep from string

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

import encode_boolean, encode_float, encode_integer, encode_string from "noomlib/serialize/json/utilities"

-- JSONWriterOptions JSONWriterOptions(table [options])
-- Represents the options used for JSONWriter
export JSONWriterOptions = (options = {}) ->
    unless type(options) == "table" then error("bad argument #1 to 'JSONWriterOptions' (expected table)")

    return {
        -- string JSONWriterOptions::indentation
        -- Represents the character sequence used for scope-based indentation
        indentation: options.indentation == nil and INDENTATION_DEFAULT_STRING or options.indentation,

        -- boolean JSONWriterOptions::in_property
        -- Represents if the JSONWriter is currently writting for a property name
        in_property: options.in_property or false,

        -- boolean JSONWriterOptions::has_sibling
        -- Represents if JSONWriter just previously wrote a sibling property
        has_sibling: options.has_sibling or false,

        -- string JSONWriterOptions::newline
        -- Represents the character sequence used for newlines
        newline: options.newline == nil and NEWLINE_DEFAULT_STRING or options.newline,

        -- string JSONWriterOptions::quote
        -- Represents the quote delimiter for strings
        quote: options.quote == nil and SYMBOL_STRING_DOUBLE or options.quote,

        -- number JSONWriterOptions::scope
        -- Represents the current indentation scope
        scope: options.scope or INDENTATION_DEFAULT_SCOPE
    }

-- JSONWriter JSONWriter(BufferWriter buffer, JSONWriterOptions [options])
-- Represents a simple interface to construct JSON strings
export JSONWriter = (buffer, options = JSONWriterOptions()) ->
    local self

    {:indentation, :has_sibling, :in_property, :newline, :quote, :scope} = options
    _write_string = buffer.write_string

    -- number get_indentation()
    -- Returns the computed indentation of the current scope
    get_indentation = () ->
        return rep(indentation, scope)

    -- void write_delimit()
    -- Writes the property delimiter to the buffer if there is a sibling property
    write_delimit = () ->
        if has_sibling then
            if indentation then _write_string(SYMBOL_PROPERTY_DELIMIT .. indentation)
            else _write_string(SYMBOL_PROPERTY_DELIMIT)

    -- void write_newline()
    -- Writes a newline to the buffer if there is a sibling property or new scope
    write_newline = () ->
        if newline and (has_sibling or new_scope)
            _write_string(newline)

    -- void write_indentation()
    -- Writes the computed indentation to the buffer if not currently in a property
    write_indentation = () ->
        if in_property
            in_property = false

        elseif not in_property and indentation and scope > 0
            _write_string(get_indentation())

    -- void scope_end(string char)
    -- Ends the current scope, with the character written to the buffer
    scope_end = (char) ->
        write_newline()

        if scope
            scope = scope - 1
            write_indentation()

        _write_string(char)

        has_sibling = true
        new_scope = false

    -- void scope_start(string char)
    -- Starts a new scope, with the character written to the buffer
    scope_start = (char) ->
        write_delimit()
        write_newline()
        write_indentation()

        _write_string(char)

        scope = scope + 1
        has_sibling = false
        new_scope = true

    -- void value_write(string string, boolean is_sibling)
    -- Writes string to the buffer, configuring the next property to be written
    value_write = (string, is_sibling) ->
        write_delimit()
        write_newline()
        write_indentation()

        _write_string(string)

        has_sibling = is_sibling
        new_scope = false

    -- void JSONWriter::close()
    -- Closes the underlying buffer
    close = () ->
        buffer.close()

    -- boolean JSONWriter::is_closed()
    -- Returns if the underlying buffer is closed
    is_closed = () ->
        return buffer.is_closed()

    -- BufferWriter JSONWriter::get_buffer()
    -- Returns the underlying buffer
    get_buffer = () ->
        return buffer

    -- JSONWriter JSONWriter::write_array_end()
    -- Writes the end of the array to the buffer
    write_array_end = () ->
        scope_end(SYMBOL_ARRAY_END)
        return self

    -- JSONWriter JSONWriter::write_start_start()
    -- Writes the start of the array to the buffer
    write_array_start = () ->
        scope_start(SYMBOL_ARRAY_START)
        return self

    -- JSONWriter JSONWriter::write_map_end()
    -- Writes the end of the map to the buffer
    write_map_end = () ->
        scope_end(SYMBOL_MAP_END)
        return self

    -- JSONWriter JSONWriter::write_map_start()
    -- Writes the start of the map to the buffer
    write_map_start = () ->
        scope_start(SYMBOL_MAP_START)
        return self

    -- JSONWriter JSONWriter::write_raw(string value)
    -- Writes the raw string to the buffer
    write_raw = (value) ->
        _write_string(value)
        return self

    -- JSONWriter JSONWriter::write_boolean(boolean value)
    -- Writes a value as a boolean to the buffer
    write_boolean = (value) ->
        string = encode_boolean(value)

        value_write(string, true)
        return self

    -- JSONWriter JSONWriter::write_float(number value)
    -- Writes a value as a float to the buffer
    write_float = (value) ->
        string = encode_float(value)

        value_write(string, true)
        return self

    -- JSONWriter JSONWriter::write_integer(number value)
    -- Writes a value as an integer to the buffer
    write_integer = (value) ->
        string = encode_integer(value)

        value_write(string, true)
        return self

    -- JSONWriter JSONWriter:write_string(string value)
    -- Writes a value as a string to the buffer
    write_string = (value) ->
        string = encode_string(value, quote)

        value_write(string, true)
        return self

    -- JSONWriter JSONWriter::write_property(string name)
    -- Writes the property name to the buffer, used for maps
    write_property = (name) ->
        string = encode_string(name, quote)

        value_write(string, false)
        _write_string(SYMBOL_PROPERTY_ASSIGN)
        in_property = true
        return self

    self = {
        :close,
        :is_closed,
        :get_buffer,
        :write_array_end,
        :write_array_start,
        :write_boolean,
        :write_map_end,
        :write_map_start,
        :write_float,
        :write_integer,
        :write_property,
        :write_raw,
        :write_string
    }

    return self

