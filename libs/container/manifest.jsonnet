local imageBase = import 'image.jsonnet';

local base = {
    new(name):: self + imageBase.new(name),
    withArchs(archs):: self + if std.type(archs) == 'array' then { archs: archs } else { archs: [archs] }
};


base
