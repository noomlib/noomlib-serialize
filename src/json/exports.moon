import JSONEncodeOptions, decode, encode from "noomlib/serialize/json/encoding"
import JSONReader from "noomlib/serialize/json/json-reader"
import JSONWriter, JSONWriterOptions from "noomlib/serialize/json/json-writer"

with exports
    .decode = decode
    .encode = encode

    .JSONReader = JSONReader
    .JSONWriter = JSONWriter
    .JSONEncodeOptions = JSONEncodeOptions
    .JSONWriterOptions = JSONWriterOptions