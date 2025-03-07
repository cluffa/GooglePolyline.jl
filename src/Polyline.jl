module Polyline

using PrecompileTools

export encode_polyline, decode_polyline

function encode_polyline(points::Vector{Tuple{Float64, Float64}})::String
    encoded = ""
    prev_lat = 0
    prev_lon = 0
    for (lat, lon) in points
        ilat = round(Int, lat * 1e5)
        ilon = round(Int, lon * 1e5)
        dlat = ilat - prev_lat
        dlon = ilon - prev_lon
        prev_lat = ilat
        prev_lon = ilon
        encoded *= encode_value(dlat)
        encoded *= encode_value(dlon)
    end
    return encoded
end

function encode_value(n::Int)::String
    shifted = n << 1
    if n < 0
        shifted = ~shifted
    end
    chunks = UInt8[]
    while true
        chunk = shifted & 0x1f
        shifted = shifted >> 5
        push!(chunks, chunk)
        shifted == 0 && break
    end
    reversed = reverse(chunks)
    for i in 1:length(reversed)-1
        reversed[i] |= 0x20
    end
    join(Char(c + 63) for c in reversed)
end

function decode_polyline(encoded::String)::Vector{Tuple{Float64, Float64}}
    points = Tuple{Float64, Float64}[]
    index = 1
    len = length(encoded)
    prev_lat = 0
    prev_lon = 0
    while index <= len
        lat, shift = decode_value(encoded, index)
        index = shift + 1
        lon, shift = decode_value(encoded, index)
        index = shift + 1
        prev_lat += lat
        prev_lon += lon
        push!(points, (prev_lat / 1e5, prev_lon / 1e5))
    end
    return points
end

function decode_value(encoded::String, index::Int)::Tuple{Int, Int}
    result = 0
    shift = 0
    byte = 0x20
    while index <= length(encoded) && (byte & 0x20) != 0
        byte = UInt8(encoded[index]) - 63
        result |= (byte & 0x1f) << shift
        shift += 5
        index += 1
    end
    if (result & 1) != 0
        result = ~(result >> 1)
    else
        result >>= 1
    end

    (result, index - 1)
end

@setup_workload begin
    # Putting some things in `@setup_workload` instead of `@compile_workload` can reduce the size of the
    # precompile file and potentially make loading faster.
    encoded = "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

    points = [
        (38.5, -120.2),
        (40.7, -120.95),
        (43.252, -126.453),
    ]

    @compile_workload begin
        # all calls in this block will be precompiled, regardless of whether
        # they belong to your package or not (on Julia 1.8 and higher)

        # should be the same
        decode_polyline(encoded)
        encode_polyline(points)

    end
end

end # module Polyline
