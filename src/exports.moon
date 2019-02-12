json = dependency "noomlib/serialize/json/exports"

with exports
    with exports.json = {}
        .decode = json.decode
        .encode = json.encode

        .JSONReader = json.JSONReader
        .JSONWriter = json.JSONWriter
        .JSONEncodeOptions = json.JSONEncodeOptions
        .JSONWriterOptions = json.JSONWriterOptions