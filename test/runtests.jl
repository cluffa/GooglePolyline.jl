using Test, Chairmarks
using GooglePolyline

encoded = "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

points = [
    (38.5, -120.2),
    (40.7, -120.95),
    (43.252, -126.453),
]

@testset "encode" begin
    @test encode_polyline(points) == encoded
end

@testset "decode" begin
    decoded = decode_polyline(encoded)

    @test length(decoded) == 3

    for ((x, y), (X, Y)) in zip(decoded, points)
        @test x ≈ X
        @test y ≈ Y
    end
end

@info "decode_polyline(encoded)"
@info @b decode_polyline(encoded)
@info "encode_polyline(points)"
@info @b encode_polyline(points)

# Scaling benchmarks
# Scaling benchmarks
function generate_data(n)
    points = [(rand() * 180 - 90, rand() * 360 - 180) for _ in 1:n]
    encoded = encode_polyline(points)
    return points, encoded
end

points_small, encoded_small = generate_data(3)
points_medium, encoded_medium = generate_data(100)
points_large, encoded_large = generate_data(1000)
points_xlarge, encoded_xlarge = generate_data(10000)

@info "Scaling Benchmarks (Decode)"
@info "Small (3 points)" @b decode_polyline(encoded_small)
@info "Medium (100 points)" @b decode_polyline(encoded_medium)
@info "Large (1000 points)" @b decode_polyline(encoded_large)
@info "XLarge (10000 points)" @b decode_polyline(encoded_xlarge)

@info "Scaling Benchmarks (Encode)"
@info "Small (3 points)" @b encode_polyline(points_small)
@info "Medium (100 points)" @b encode_polyline(points_medium)
@info "Large (1000 points)" @b encode_polyline(points_large)
@info "XLarge (10000 points)" @b encode_polyline(points_xlarge)
