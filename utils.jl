# TODO: clean-up unused functions

using Dates

################################################################################
##
#                               Helper Functions
#
################################################################################

"""
Get the date of a post with a fall back to the file edit stat
"""
function get_date(p)
  date = pagevar(p, "date")
  if isnothing(date)
      return Date(Dates.unix2datetime(stat(p * ".md").ctime))
  end
  return date
end

function page_tag_list()
  pagetags = globvar("fd_page_tags")
  pagetags === nothing && return ""
  cur_page = splitext(locvar("fd_rpath"))[1]
  haskey(pagetags, cur_page) || return nothing
  
  tags = pagetags[splitext(locvar("fd_rpath"))[1]] |> collect |> sort
  return tags
end

################################################################################
##
#                               Resume
#
################################################################################

function hfun_resume_title(varargs)
  position = string(varargs[1])
  date1 = string(varargs[2])
  date2 = string(varargs[3])

  io = IOBuffer()
  write(io, """<div class="resume-title"><div class="resume-pos">$position</div>""")
  write(io, """<div class="resume-date">$date1 - $date2</div></div>""")
  return String(take!(io))
end

function hfun_resume_subtitle(varargs)
  org = string(varargs[1])
  place = string(varargs[2])

  io = IOBuffer()
  write(io, """<div class="resume-subtitle"><div class="resume-org">$org</div>""")
  write(io, """<div class="resume-loc">$place</div></div>""")
  return String(take!(io))
end

################################################################################
##
#                               Page Header Functions
#
################################################################################

function hfun_pageheader()
  title_str = string(locvar("title"))
  title_block = """<h1>$title_str</h1>"""
  date_str = Dates.format.(locvar("date"), globvar("date_format"))
  date_block = """<span class="post-date">$date_str</span>"""

  tags = page_tag_list()
  if tags === nothing
    subheader_block = """<div class="subheader">$date_block</div>"""
    # return """<div class="page-header"> $title_block $date_block </div>"""
  else
    tag_block = hfun_page_tags()
    subheader_block = """<div class="subheader">$date_block $tag_block</div>"""
  end
  return """<div class="page-header"> $title_block $subheader_block</div>"""
end

@delay function hfun_page_tags()
  pagetags = globvar("fd_page_tags")
  pagetags === nothing && return ""
  io = IOBuffer()
  tags = pagetags[splitext(locvar("fd_rpath"))[1]] |> collect |> sort
  several = length(tags) > 1
  write(io, """<div class="tags">$(hfun_icon_tag())""")
  for tag in tags[1:end-1]
      t = replace(tag, "_" => " ")
      write(io, """<a href="/tag/$tag/">$t</a>, """)
  end
  tag = tags[end]
  t = replace(tag, "_" => " ")
  write(io, """<a href="/tag/$tag/">$t</a></div>""")
  return String(take!(io))
end

################################################################################
##
#                               Custom HTML Functions
#
################################################################################


function hfun_jlpkg(packagename)
  name = string(packagename[1])
  name = endswith(name, ".jl") ? name : name * ".jl"
  link_to = "https://github.com/search?q=$name&type=Repositories"
  return """<a href="$link_to">$name</a>"""
end

# TODO: Fix this function
# function hfun_postfig(varargs)
#   # Unpack arguments
#   sizestr = ""
#   description = ""
#   if length(varargs) == 1
#     figure_num = string(varargs[1])
#   elseif length(varargs) == 2
#     figure_num = string(varargs[1])
#     description = varargs[2]
#   elseif length(varargs) == 3
#     figure_num = string(varargs[1])
#     description = varargs[2]
#     size = parse(Int, varargs[3])
#     sizestr = """style="width: $size%;" """
#   else
#     return @warn "Wrong number of arguments in postfig HTML function"
#   end

#   alttext = """alt="$description" """

#   base_name = split(splitext(locvar("fd_rpath"))[1], "\\")[2]
#   figure_name = "$base_name" * "_fig" * figure_num * "."

#   img_list = readdir("./_assets/blog_images")
#   filter!(f -> occursin(figure_name, f), img_list)

#   if length(img_list) == 1
#     img_path = "/assets/blog_images/" * img_list[1]
#     io = IOBuffer()
#     generate_figure!(io, figure_num, description, img_path, sizestr, alttext)
#     return String(take!(io))
#   else
#     generated_images_dir = "./__site/assets/blog/$base_name/code/output"
#     @info "Figure: searching for generated images for $base_name in $generated_images_dir"
#     # Check if there is a folder for code generated output
#     if isdir(generated_images_dir)
#       generated_images = readdir("./__site/assets/blog/$base_name/code/output")      
#       filter!(f -> startswith(f, "fig$figure_num"), generated_images)
      
#       # If there is exactly one image in the generated output
#       if length(generated_images) == 1
#         img_path = "/assets/blog/$base_name/code/output/" * generated_images[1]
#         @info "Image found: $img_path"
  
#         io = IOBuffer()
#         generate_figure!(io, figure_num, description, img_path, sizestr, alttext)
#         return String(take!(io))
#       # else
#         # @warn "Figure could not be found"
#       end
#     # else 
#     #   @warn "Figure could not be found"
#     end
    
#   end
#   @warn "Figure $figure_num in $base_name could not be found"
#   return ""
# end

# write(io, """<figure>""")
# write(io, """<img src="$img_path" alt="$description" $sizestr $alttext >""")
# write(io, """<figcaption><span class="fig-num">Figure $figure_num:</span> $description</figcaption>""")
# write(io, """</figure>""")
# function generate_figure!(io::IOBuffer, figure_num, description, img_path, sizestr, alttext="")
#   write(io, """<figure>""")
#   write(io, """<img src="$img_path" alt="$description" $sizestr $alttext >""")
#   write(io, """<figcaption><span class="fig-num">Figure $figure_num:</span> $description</figcaption>""")
#   write(io, """</figure>""")
# end
# # __site/assets/blog/blender_dithering_01/code/output/fig2.png

# function hfun_gallery(varargs)
#   img_nums = string(varargs[1])
#   img_nums = split(replace(img_nums, r"[\[\]]" => ""), ",")
#   # img_nums = parse.(Int, img_nums)

#   height = 500
#   if length(varargs) ≥ 2
#     height = string(varargs[2])
#     @info "Setting gallery height to $height"
#   end
  
#   base_name = split(splitext(locvar("fd_rpath"))[1], "\\")[2]

#   img_list = readdir("_assets/blog_images/")
#   # filter!(f -> occursin(base_name, f), img_list)
#   @show base_name
#   # @show img_list
#   img_dict = Dict(n => first(filter(i -> occursin("fig$n", i), img_list)) for n in img_nums)
#   @show img_dict
  
#   io = IOBuffer()
#   write(io, """base_name = $base_name""") # debug
#   write(io, """img_dict = $img_dict""") # debug

#   # write(io, """<div class="slider">""")
#   # write(io, """<ul class="slider" style="height: $(height)px;">""")
#   # for (i,n) in enumerate(img_nums)
#   #   img_path = "/assets/blog_images/" * img_dict[n]
#   #   # @info img_path
#   #   slide_num_str = "slide$(n)"
#   #   write(io, "<li>")
#   #   # write(io, """<span class="helper"></span>""")
#   #   write(io, """<input type="radio" id="$slide_num_str" name="slide" checked>""")
#   #   write(io, """<label for="$slide_num_str" style="left:$(1.5*(i))em"></label>""")
#   #   # write(io, """<div class="helper">""")
#   #   write(io, """<img src="$img_path" alt="Panel 1">""")
#   #   # write(io, """</div">""")
#   #   # write(io, """$n""")
#   #   write(io, "</li>")
#   # end
#   # write(io, "</ul>")
#   # write(io, "</div>")
#   return String(take!(io))
# end



################################################################################
##
#                               Post Lists
#
################################################################################

"""
Converts a blog file name ending with md into a 
"""
mdfile_to_rpath(mdfile) = ".\\blog\\" * splitext(mdfile)[1]



"""
Lists all blog posts
TODO: add pagination
TODO: add optional images
TODO: add desc
"""
@delay function hfun_posts()
  io = IOBuffer()
  mdfilelist = readdir("blog")
  rpaths = mdfile_to_rpath.(filter(f -> endswith(f, ".md"), mdfilelist))
  sort!(rpaths, by=get_date, rev=true)

  # Find all posts and store as list of named tuples
  # postlist = []
  # for rpath in rpaths
  #   title = pagevar(rpath, "title")
  #   if isnothing(title)
  #     title = titlecase(replace(last(split(rpath, "\\")), "_" => " "))
  #     @warn "Title at $rpath is nothing. Resorting to default title: $title"
  #   end
  #   date = get_date(rpath)
  #   date_str = isnothing(date) ? "" : Dates.format.(date, "u-Y")
  #   url = get_url(rpath)
  #   push!(postlist, (;rpath, date, title, date_str, url))
  # end
  # sort!(postlist, by = x -> x.date, rev=true)

  # # Write sorted output to with styled HTML
  # write(io, """<ul class="post-list">""")
  # for p in postlist
  #   write(io, """<li><a class="post-title" href="$(p.url)">$(p.title)</a><span class="post-date">$(p.date_str)</span></li>\n""")
  # end
  # write(io, "</ul>")
  # return String(take!(io))

  io = IOBuffer()
  post_list_from_paths(io, rpaths)
  return String(take!(io))
end

################################################################################
##
#                               Tag Lists
#
################################################################################

##  https://github.com/tlienart/tlienart.github.io/blob/master/utils.jl
@delay function hfun_list_tags()
  tagpages = globvar("fd_tag_pages")
  # @info tagpages
  if tagpages === nothing
      return ""
  end
  tags = tagpages |> keys |> collect |> sort
  tags_count = [length(tagpages[t]) for t in tags]

  io = IOBuffer()
  write(io, "<ul>")
  for (t, c) in zip(tags, tags_count)
    write(io, """
    <li>
      <a href="/tag/$t/" class="tag-link">$(replace(t, "_" => " "))</a>
      <span class="tag-count"> ($c)</span>
    </li>
    """)
  end
  write(io, "</ul>")
  return String(take!(io))
end

"""
Goes on pages like `/tag/3d_printing/`. Not to be used in other pages.
"""
function hfun_custom_taglist()::String
  tag = locvar(:fd_tag)
  rpaths = globvar("fd_tag_pages")[tag]
  sort!(rpaths, by=get_date, rev=true)

  io = IOBuffer()
  post_list_from_paths(io, rpaths)
  return String(take!(io))
end

function post_list_from_paths(io, paths)
  write(io, """<ul class="post-list">""")
  for p in paths
      date = get_date(p)
      date_str = Dates.format.(date, "u-Y")
      title = string(pagevar(p, "title"))
      # link = "./" * split(p, "\\")[end] * "/" * "index.html"
      url = get_url(p)
      write(io, """<li><a class="post-title" href="$url">$title</a><span class="post-date">$date_str</span></li>\n""")
  end
  write(io, "</ul>")
  return io
end


################################################################################
##
#                               Custom Icons
#
################################################################################

hfun_be_logo(vararg)  = """<svg width="$(vararg[1])" height="$(vararg[1])" viewBox="0 0 100 100"><defs><style>.cls-1{fill:#141f38}</style></defs><path d="m 52.526941,10 -7.723555,2.81111 v 12.1492 l 2.609363,0.94978 7.723794,-2.81112 v -9.48178 l 0.03045,-0.0111 0.694462,0.25273 v 5.62223 l 8.57329,3.12048 c 3.618366,1.31699 6.523647,5.31957 6.523647,8.98766 0,0.0968 -0.0027,0.19194 -0.0069,0.28623 l 0.481617,0.17533 c 3.618374,1.31697 6.523645,-0.5709 6.523645,-4.23898 0,-1.70409 -0.627681,-3.48004 -1.661941,-5.02571 1.459283,1.74127 2.386843,3.91995 2.386843,5.99225 0,2.86568 -1.773209,4.64481 -4.274371,4.65806 -0.700329,0.004 -1.457752,-0.131 -2.249273,-0.41909 L 61.883399,29.27713 c -0.842681,-0.30671 -1.626935,-0.31576 -2.268859,-0.0821 l -7.723561,2.81112 c -0.993046,0.36144 -1.645422,1.30412 -1.645422,2.62565 1e-6,2.17577 1.767986,4.61145 3.914281,5.39263 l 10.210219,3.78687 0.0045,0.002 -2.41e-4,2.4e-4 c 3.618371,1.31699 6.523646,5.31957 6.523646,8.98765 0,0.0999 -0.0032,0.19804 -0.0073,0.29521 1.14e-4,-0.003 4.57e-4,-0.006 9.39e-4,-0.01 0.01078,0.004 0.483978,0.17721 0.483978,0.17721 3.617164,1.31513 6.52105,-0.57247 6.52105,-4.23969 0,-1.7045 -0.627923,-3.48095 -1.662649,-5.02688 1.459722,1.74141 2.387551,3.92076 2.387551,5.99343 0,2.86499 -1.772487,4.64375 -4.272721,4.65782 -0.700067,0.004 -1.457074,-0.13046 -2.248329,-0.41814 0,0 -1.202154,-0.44013 -1.274243,-0.46652 C 64.985036,51.6335 35.56809,40.86241 35.56809,40.86241 l -9.39e-4,-2.4e-4 -0.0016,-4.6e-4 -0.01439,0.005 c 0.0046,-0.002 0.0098,-0.004 0.01439,-0.005 -1.977219,-0.71965 -3.811664,-0.74397 -5.309812,-0.19869 l -7.723559,2.81112 c -2.312063,0.84153 -3.823433,3.04002 -3.823433,6.13335 0,5.09772 4.104381,10.75239 9.133011,12.58267 l 0.706024,0.25697 9.767064,3.55466 c 0.54755,0.19929 1.002105,0.68402 1.199204,1.22634 -0.146269,-0.1089 -0.305623,-0.19817 -0.474302,-0.25956 L 28.566891,63.15615 c -0.310152,-0.11288 -0.616539,-0.24129 -0.918869,-0.38227 l -5.116045,1.86186 c -2.312069,0.84152 -3.823197,3.03979 -3.823197,6.13311 0,5.09771 4.104381,10.75264 9.133011,12.58291 L 46.108049,90 53.831606,87.18888 V 84.54339 L 35.565602,77.89515 c -3.618372,-1.31698 -6.523882,-5.31958 -6.523883,-8.98766 0,-0.0967 0.0028,-0.1918 0.0068,-0.28599 l -0.481615,-0.17533 c -3.618371,-1.31698 -6.523647,0.5709 -6.523647,4.23899 0,1.70407 0.627679,3.48005 1.661942,5.02569 -1.459284,-1.74125 -2.386844,-3.91994 -2.386844,-5.99224 0,-2.86569 1.773207,-4.64482 4.274374,-4.65805 0.700325,-0.004 1.457754,0.13099 2.249272,0.41908 l 10.472382,3.81187 c 0.842679,0.30671 1.627172,0.316 2.269094,0.0824 l 7.723559,-2.81135 c 0.993048,-0.36143 1.645187,-1.30388 1.645187,-2.62541 0,-2.17579 -1.76775,-4.61145 -3.914046,-5.39264 L 35.565561,56.73264 c -3.618371,-1.31698 -6.523882,-5.31957 -6.523883,-8.98765 0,-0.0963 0.0026,-0.19102 0.0066,-0.28482 -0.01074,-0.004 -0.483976,-0.17721 -0.483976,-0.17721 -3.617166,-1.31513 -6.521051,0.57248 -6.521051,4.23968 0,1.70452 0.627921,3.48096 1.66265,5.02689 -1.459726,-1.74141 -2.387552,-3.92075 -2.387552,-5.99342 0,-2.865 1.772487,-4.64376 4.272721,-4.65783 0.700067,-0.004 1.457075,0.13045 2.24833,0.41815 0,0 1.202153,0.44012 1.274241,0.46651 2.286761,0.83731 31.089223,11.38343 35.260638,12.9017 1.977222,0.71965 3.811663,0.74396 5.30981,0.19869 l 7.723556,-2.81112 c 2.312071,-0.84153 3.823439,-3.03979 3.823439,-6.13312 0,-5.09772 -4.104619,-10.75239 -9.13325,-12.58266 L 71.361839,38.0834 61.594775,34.52874 c -0.547552,-0.19929 -1.0021,-0.68401 -1.199201,-1.22634 0.146268,0.10891 0.305618,0.19818 0.474299,0.25957 l 10.472856,3.81163 c 0.310154,0.11289 0.61654,0.24129 0.91887,0.38228 l 5.206221,-1.89485 c 2.31207,-0.84153 3.823433,-3.03979 3.823433,-6.13312 0,-5.0977 -4.104384,-10.75263 -9.133013,-12.5829 z" /></svg>"""
hfun_icon_tag() = """<a href="/blog/#articles_by_tag/" id="tag-icon"><svg width="15" height="15" viewBox="0 0 512 512"><defs><style>.cls-1{fill:#141f38}</style></defs><path d="M 48.284271,8.2842712 A 40,40 0 0 0 8.2842712,48.284271 V 192.28427 A 96.568542,96.568542 0 0 0 36.569427,260.56943 L 267.99911,491.99911 a 40,40 0 0 0 56.57032,0 L 491.99911,324.56943 a 40,40 0 0 0 0,-56.57032 L 260.56943,36.569427 A 96.568542,96.568542 0 0 0 192.28427,8.2842712 Z M 136.28427,104.28427 a 32,32 0 0 1 32,32 32,32 0 0 1 -32,32 32,32 0 0 1 -32,-32 32,32 0 0 1 32,-32 z" /></svg></a>"""