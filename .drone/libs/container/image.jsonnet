local base = {
    new(name):: self.withName(name),
    withName(name):: self + { name: name },
    withTags(tags)::  self + if std.type(tags) == 'array' then { tags: tags } else { tags: [tags] }
};


base
