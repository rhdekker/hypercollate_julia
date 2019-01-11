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






function partition_block_into_groups(all_nodes)
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













