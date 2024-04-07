# This file was generated, do not modify it. # hide
using Images

function bayer_matrix(size=1)
    M = [0 2; 3 1]
    
    for i=2:size
        M = @. [(4*M) (4*M+2); (4*M+3) (4*M+1)]
    end
    return M./ 2^(2*size)
end

img_size = 128
imgs = []
for n = 1:4
    bm = bayer_matrix(n)
    reps = convert(Int, img_size/2^n)
    bm = repeat(bm, inner=(reps,reps))
    push!(imgs, bm)
end
padimg = ones((128, 32))
output = hcat(imgs[1], padimg, imgs[2], padimg, imgs[3], padimg, imgs[4])
save(joinpath(@OUTPUT, "fig2.png"), colorview(Gray, output))