function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
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
