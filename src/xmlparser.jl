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



# traverse all nodes of the XML tree in depth first fashion
# without recursion
# Initialize the deque with the children of the root
# daarna halen we er steeds 1 op
# Mocht dat een element zijn
# dan zetten we de kinderen daarvan weer op de deck.
# NOTE: maybe a stack is better here?
# for now we create an array with the result
# implementing it as an iterator would be nicer
function create_an_array_of_the_xml_nodes(root)
    result = Union{AbstractString, ETree}[]
    deck = deque(Union{AbstractString, ETree})
    push!(deck, root)

    while !isempty(deck)
        a = popfirst!(deck)
        push!(result, a)
        if typeof(a) == ETree
            for element in reverse(a.elements)
                pushfirst!(deck, element)
            end
        end
    end
    return result
end

function bla()
    println("Called")
    vg = VariantGraphNode[]
    startNode = StartNode()
    push!(vg, startNode)

    vgedges = []
    last_node = startNode

    all_nodes = create_an_array_of_the_xml_nodes(root)
    for node in all_nodes
        if typeof(node) == String
            println(node)
            # here we want to create a text node for in the variant hypergraph
            textNode = TextNode()
            push!(vg, startNode)
            # add an extra edge
            push!(vgedges, (last_node, textNode))
            last_node = textNode
        elseif typeof(node) == ETree
            println(node.name)
        end
    end

    # create end node
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

bla()



















