# Parent file to run all scripts which may generate
# some output that you want to display on the website.
# this can be used as a tester to check that all the code
# on your website runs properly.

dir = @__DIR__

"""
    genplain(s)

Small helper function to run some code and redirect the output (stdout) to a file.
"""
# function genplain(s::String)
#     open(joinpath(dir, "output", "$(splitext(s)[1]).txt"), "w") do outf
#         redirect_stdout(outf) do
#             include(joinpath(dir, s))
#         end
#     end
# end

function genplain(s::String)
    inpath = joinpath(dir, s)
    outpath = joinpath(dir, "output", "$(splitext(s)[1]).out")
    println(inpath)
    println("--> ", outpath)
    open(joinpath(dir, "output", "$(splitext(s)[1]).out"), "w") do outf
        redirect_stdout(outf) do
            include(joinpath(dir, s))
        end
    end
end

# output

# genplain("script1.jl")
# genplain("beam_deflection_01.jl")
# genplain("beam_deflection_02.jl")

# plots

# include("script2.jl")
include("beam_deflection_01.jl")
include("beam_deflection_02.jl")
include("blender_dithering_01.jl")
include("diagnostic_tests_02_1.jl")
include("diagnostic_tests_02_2.jl")
include("favorite_shape_01.jl")
