local base = {
    new():: self + {},
    withKind(kind):: self + { kind: kind },
    withName(name):: self + { name: name}
};


base