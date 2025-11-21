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
@info "Small (3 points)"
@info @b decode_polyline(encoded_small)
println()
@info "Medium (100 points)" 
@info @b decode_polyline(encoded_medium)
println()
@info "Large (1000 points)" 
@info @b decode_polyline(encoded_large)
println()
@info "XLarge (10000 points)" 
@info @b decode_polyline(encoded_xlarge)
println()
@info "Scaling Benchmarks (Encode)"
@info "Small (3 points)" 
@info @b encode_polyline(points_small)
println()
@info "Medium (100 points)" 
@info @b encode_polyline(points_medium)
println()
@info "Large (1000 points)" 
@info @b encode_polyline(points_large)
println()
@info "XLarge (10000 points)" 
@info @b encode_polyline(points_xlarge)
