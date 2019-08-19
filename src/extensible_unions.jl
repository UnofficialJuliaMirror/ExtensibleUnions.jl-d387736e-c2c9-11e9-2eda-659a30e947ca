function extensibleunion!(@nospecialize(u))
    global _registry_extensibleunion_to_genericfunctions
    global _registry_extensibleunion_to_members
    if !isconcretetype(u)
        throw(ArgumentError("The provided type must be a concrete type"))
    end
    if !isstructtype(u)
        throw(ArgumentError("The provided type must be a struct type"))
    end
    if length(fieldnames(u)) > 0
        throw(ArgumentError("The provided type must have no fields"))
    end
    if !isimmutable(u())
        throw(ArgumentError("The provided type must be an immutable type"))
    end
    if !(supertype(u) === Any)
        throw(ArgumentError("The immediate supertype of the provided type must be Any"))
    end
    if !haskey(_registry_extensibleunion_to_members, u)
        _registry_extensibleunion_to_genericfunctions[u] = Set{Any}()
        _registry_extensibleunion_to_members[u] = Set{Any}()
    end
    _update_all_methods_for_extensibleunion!(u)
    return u
end

function isextensibleunion(@nospecialize(u))
    global _registry_extensibleunion_to_members
    return haskey(_registry_extensibleunion_to_members, u)
end

function addtounion!(@nospecialize(u), varargs...)
    return addtounion!(u, varargs)
end

function addtounion!(@nospecialize(u), @nospecialize(varargs::Tuple))
    global _registry_extensibleunion_to_members
    if isextensibleunion(u)
        for i = 1:length(varargs)
            push!(_registry_extensibleunion_to_members[u], varargs[i])
        end
    else
        throw(ArgumentError("First argument must be a registered extensible union."))
    end
    _update_all_methods_for_extensibleunion!(u)
end

function unioncontains(@nospecialize(u), @nospecialize(t))
    global _registry_extensibleunion_to_members
    if isextensibleunion(u)
        return t in _registry_extensibleunion_to_members[u]
    else
        throw(ArgumentError("First argument must be a registered extensible union."))
    end
end