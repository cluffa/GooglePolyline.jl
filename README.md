# GooglePolyline.jl

[![CI](https://github.com/cluffa/GooglePolyline.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/cluffa/GooglePolyline.jl/actions/workflows/CI.yml)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://cluffa.github.io/GooglePolyline.jl/stable)

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

