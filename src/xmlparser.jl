#=
xmlparser:
- Julia version: 1.0.3
- Author: rhdekker
- Date: 2019-01-09
=#

using LibExpat
using DataStructures

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

xml = "<xml>Mondays are <del>well good</del><add>def bad</add>!</xml>"
# the_streaming_way_of_doing_things()

root = xp_parse(xml)
# dump(root)

# ik moet een methode hebben die gewoon over alle elements itereert.
# maar het eerste etree element is al meteen de root..
# Zijn er traversals ofzo?


# wat we willen doen is alle text elementen uit de xml tree halen
# en die dan in een variant graph achtige constructie plaatsen
# Zoals elke variant graph is er een start en end vertex
# Eigenlijk moeten we hier ook tokenizen
# dus dan na de start node zijn er twee text nodes
# dan een divergence node
# met twee text nodes (well good) aan de ene kant
# en twee texdt nodes (def bad) ana de andere kant.
# had de java versie al divergence en convergence nodes?

# moet ik zelf een graph struct aanmaken?
# of een liberary daarvoor gebruiken
# mijn eerste gevoel is om het gewoon even zelf te doen
# even wat simpele structs te definieren
abstract type VariantGraphNode end
struct TextNode <: VariantGraphNode end
struct StartNode <: VariantGraphNode end

vg = VariantGraphNode[]
push!(vg, StartNode())

#TODO: dit moet recursief om alle elementen te processen...
# ik hou niet zo van recursie, kan dat echt niet anders?
# Er zijn wel generators in julia
# lightxml liberary lijkt wel een iterator te hebben
# dat is ook alleen maar van de directe kinderen
# misschien een priority queue vullen?
# waarbij bij het aflopen van de queue steeds weer nodes op de queue worden gezet.


# We zetten alle kinderen van de root op een deck
# daarna halen we er steeds 1 op
# Mocht dat een element zijn
# dan zetten we de kinderen daarvan weer op de deck.

deck = deque(Union{AbstractString, ETree})
for element in root.elements
    push!(deck, element)
end
println(deck)

while !isempty(deck)
    a = popfirst!(deck)
    if typeof(a) == String
        println(a)
    elseif typeof(a) == ETree
        println(a)
        for element in reverse(a.elements)
            pushfirst!(deck, element)
        end
    end
end



















