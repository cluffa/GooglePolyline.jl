# GooglePolyline.jl

A Julia implementation for encoding and decoding [Google's Polyline Algorithm Format](https://developers.google.com/maps/documentation/utilities/polylinealgorithm).

## Usage

```julia
using GooglePolyline

# Encode coordinates
points = [
    (38.5, -120.2),
    (40.7, -120.95),
    (43.252, -126.453)
]
encoded = encode_polyline(points)
# => "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

# Decode polyline string
decoded = decode_polyline(encoded)
# => [(38.5, -120.2), (40.7, -120.95), (43.252, -126.453)]
```

## Reference

For more information about the algorithm, see Google's [Polyline Algorithm Format](https://developers.google.com/maps/documentation/utilities/polylinealgorithm).

