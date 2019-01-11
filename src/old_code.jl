#=
old_code:
- Julia version: 1.0.3
- Author: rhdekker
- Date: 2019-01-11
=#

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


