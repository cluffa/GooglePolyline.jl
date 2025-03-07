module Polyline

using PrecompileTools: @setup_workload, @compile_workload

export encode_polyline, decode_polyline

"""
    encode_polyline(points::Vector{Tuple{Float64, Float64}})::String

Encodes a sequence of lat,lng points into a polyline string using Google's encoding algorithm.
"""
function encode_polyline(points::Vector{Tuple{Float64, Float64}})::String
    encoded = ""
    prev_lat = 0  # Store the previous lat value for delta encoding
    prev_lon = 0  # Store the previous lng value for delta encoding
    for (lat, lon) in points
        # Step 1: Multiply each latitude and longitude by 1e5 and round to integer
        ilat = round(Int, lat * 1e5)
        ilon = round(Int, lon * 1e5)
        # Step 2: Calculate the difference from previous point
        dlat = ilat - prev_lat
        dlon = ilon - prev_lon
        # Store current points for next iteration
        prev_lat = ilat
        prev_lon = ilon
        # Step 3: Encode each latitude and longitude difference
        encoded *= encode_value(dlat)
        encoded *= encode_value(dlon)
    end
    return encoded
end

"""
    encode_value(n::Int)::String

Encodes a single coordinate difference value using Google's encoding algorithm.
"""
function encode_value(n::Int)::String
    # Step 4: Take the binary value and left-shift it one bit
    # Step 5: If the original number is negative, invert this encoding
    value = n < 0 ? ~(n << 1) : (n << 1)
    chunks = UInt8[]
    # Step 6: Break the binary value out into 5-bit chunks
    while value >= 0x20
        # Step 7: For each 5-bit chunk, OR it with 0x20 if another bit chunk follows
        push!(chunks, UInt8((0x20 | (value & 0x1f))))
        value >>= 5
    end
    # Add the last chunk
    push!(chunks, UInt8(value))
    # Step 8: Convert each value to decimal and add 63
    # Step 9: Convert each decimal value to its ASCII equivalent
    return join(Char.(chunks .+ 63))
end

"""
    decode_polyline(encoded::String)::Vector{Tuple{Float64, Float64}}

Decodes a polyline string into a sequence of lat,lng points using Google's encoding algorithm.
"""
function decode_polyline(encoded::String)::Vector{Tuple{Float64, Float64}}
    points = Tuple{Float64, Float64}[]
    index = 1
    len = length(encoded)
    prev_lat = 0  # Store the previous lat value for delta decoding
    prev_lon = 0  # Store the previous lng value for delta decoding
    while index <= len
        # Step 1: Decode the latitude difference
        lat, shift = decode_value(encoded, index)
        index = shift + 1
        # Step 2: Decode the longitude difference
        lon, shift = decode_value(encoded, index)
        index = shift + 1
        # Step 3: Add previous values to restore original coordinates
        prev_lat += lat
        prev_lon += lon
        # Step 4: Convert back to decimal degrees by dividing by 1e5
        push!(points, (prev_lat / 1e5, prev_lon / 1e5))
    end
    return points
end

"""
    decode_value(encoded::String, index::Int)::Tuple{Int, Int}

Decodes a single coordinate difference value from the polyline string.
Returns the decoded value and the new string index.
"""
function decode_value(encoded::String, index::Int)::Tuple{Int, Int}
    result = 0
    shift = 0
    byte = 0x20
    # Step 1: Read chunks of 5 bits until we find a chunk without the continuation bit
    while index <= length(encoded) && (byte & 0x20) != 0
        # Step 2: Each byte is ASCII value - 63 to restore original 5-bit chunk
        byte = UInt8(encoded[index]) - 63
        # Step 3: Accumulate the 5-bit chunks into the result
        result |= (byte & 0x1f) << shift
        shift += 5
        index += 1
    end
    # Step 4: Handle the sign bit and right-shift to restore original value
    if (result & 1) != 0
        result = ~(result >> 1)  # Restore negative values
    else
        result >>= 1  # Restore positive values
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
