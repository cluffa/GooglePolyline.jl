using Test, Chairmarks
using Polyline

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

@info @b decode_polyline(encoded)
@info @b encode_polyline(points)
