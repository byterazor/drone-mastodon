#
# jsonnet library representing one drone build
#
local trigger           = import '../drone/trigger.jsonnet';

local base = {
    secrets: [],
    pipelines: [],
    finishpipelines: [],
    initpipelines: [],
    new():: self + {},
    withPushGithub(github):: self.withSecrets(github.token) + {github: github},
    withSecrets(secrets)::
         local prev = if std.objectHas(self,'secrets') then self.secrets else [];
         local s = if std.type(secrets) == 'array' then secrets else [secrets];
         self + { secrets: prev + s },
    withPipelines(pipelines):: self + {pipelines: pipelines},
    withInitPipelines(pipelines):: self + {initpipelines: pipelines},
    withFinishPipelines(pipelines):: self + {finishpipelines:  pipelines},
    render():: [
                s for s in self.secrets
               ]
               +
               [
                p for p in self.initpipelines
               ]
               +
               [
                p.withDependsOn([
                    p2.name for p2 in self.initpipelines
                ])
                for p in self.pipelines
               ]
               +
               [
                p.withDependsOn([
                    p2.name for p2 in self.pipelines
                ])
                for p in self.finishpipelines
               ]

               +
               [
                if std.objectHas(self, "github") then self.github.push().withDependsOn([
                    p2.name for p2 in self.finishpipelines
                ]).withTrigger(trigger.new()+ trigger.withBranch("main") + trigger.withStatus("success") + trigger.withEvent(["push"]))
               ]
};


base
