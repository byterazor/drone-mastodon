local base      = import 'base.jsonnet';
local platform  = import 'platform.jsonnet';

local pipeline = {
    dependPipelines:: [],
    new():: (self + base.new().withKind("pipeline"))
                             .withPlatform(platform.new())
                             .withType("kubernetes"),
    withType(type):: self + { type: type },
    withPlatform(platform):: self + { platform: platform },
    withTrigger(t):: self + { trigger: t },
    withSteps(steps):: self + if std.type(steps) == 'array' then { steps: steps } else { steps: [steps] },
    withDependsOn(n):: self + { depends_on: n },
    withDependPipelines(pipelines):: self + {dependPipelines:: pipelines},
    withoutClone():: self + { clone: {disable: true} },
    withVolumes(volumes):: self + if std.type(volumes) == 'array' then { volumes: volumes } else { volumes: [volumes] },
    render():: []
};

pipeline