#
# jsonnet library representing one drone build 
#

local base = {
    secrets: [],
    pipelines: [],
    finishpipelines: [],
    initpipelines: [],
    new():: self + {},
    withSecrets(secrets):: self + if std.type(secrets) == 'array' then {secrets: secrets} else { secrets: [secrets] },
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
}; 


base