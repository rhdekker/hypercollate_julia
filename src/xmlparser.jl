#=
xmlparser:
- Julia version: 1.0.3
- Author: rhdekker
- Date: 2019-01-09
=#

using LibExpat

struct Container
    name::String
    id::Int64
end

function the_streaming_way_of_doing_things()
    tag_name = "test"
    L = []
    cb = XPCallbacks()
    cb.start_element = function (h, name, attrs)
        c = Container(name, 123)
        push!(L, c)
        return c
    end

    parse(xml, cb)
    print(L)

end

xml = "<xml> text </xml>"
# the_streaming_way_of_doing_things()









