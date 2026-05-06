using Documenter
using GooglePolyline

makedocs(
    sitename = "GooglePolyline.jl",
    format = Documenter.HTML(),
    modules = [GooglePolyline],
    checkdocs = :exports,
    warnonly = [:missing_docs, :cross_references],
    pages = [
        "Home" => "index.md",
    ]
)

deploydocs(
    repo = "github.com/cluffa/GooglePolyline.jl.git",
    devbranch = "main"
)
