using Documenter
using GooglePolyline

makedocs(
    sitename = "GooglePolyline.jl",
    format = Documenter.HTML(),
    modules = [GooglePolyline],
    pages = [
        "Home" => "index.md",
    ]
)

deploydocs(
    repo = "github.com/cluffa/GooglePolyline.jl.git",
    devbranch = "main"
)
