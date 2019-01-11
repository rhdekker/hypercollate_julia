#=
xmlparser:
- Julia version: 1.0.3
- Author: rhdekker
- Date: 2019-01-09
=#

using LibExpat
using DataStructures

# variant graph types and structs
abstract type VariantGraphNode end
struct TextNode <: VariantGraphNode end
struct StartNode <: VariantGraphNode end

# xml types and structs
mutable struct XMLBlock
    tag::String
    content::String
    tail::String
end


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
        a = pop!(deck)
        push!(result, a)
        if typeof(a) == ETree
            for element in reverse(a.elements)
                push!(deck, element)
            end
        end
    end
    return result
end

function bla(all_nodes)
    println("Called")
    vg = VariantGraphNode[]
    startNode = StartNode()
    push!(vg, startNode)

    vgedges = []
    last_node = startNode

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






function convert_later(all_nodes)
    # we willen over alle nodes lopen steeds per twee, dus we houden een previous bij..
    previous = undef
    for node in all_nodes
        if previous == undef
            previous = node
            continue
        end
        # hmm dit doe ik niet goed
    end
end

function convert_to_xml_blocks(all_nodes)
    xml_blocks = []
    for node in all_nodes
        if typeof(node) == ETree
            xml_block = XMLBlock(node.name, "", "")
            push!(xml_blocks, xml_block)
        else
            # node is a String
            xml_block = last(xml_blocks)
            if xml_block.content == ""
                xml_block.content = node
            else
                xml_block.tail = node
            end
        end
    end
    return xml_blocks
end

function is_xml_block_textual_variation_or_not(xml_block)
    # TODO: this should really be a constant
    variation_tags = ["del", "add"]
    return xml_block.tag in variation_tags
end

function main()
    xml = "<xml>Mondays are <del>well good</del><add>def bad</add>!</xml>"
    root = xp_parse(xml)
    # dump(root)

    all_nodes = create_an_array_of_the_xml_nodes(root)
    blocks = convert_to_xml_blocks(all_nodes)
    println(blocks)
    for block in blocks
        println(is_xml_block_textual_variation_or_not(block))
    end
end

main()



    # Ik wil over de nodes lopen en die op een andere manier bij elkaar groeperen zodat
    # het werken met mixed content xml niet meer zo onvoorspelbaar is.
    # Mixed content XML is in te delen in blokken met (tag, attr, textual content en tail textual content)
    # Deze constructie heb ik voor het eerst gezien in de XML parser van Python
    # Deze aanpak heeft voor en nadelen, maar in dit geval kan het zorgen voor een voorspelbare structuur
    # op basis waarvan we verdere bewerkingen kunnen doen.









    # OUDE comments
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













