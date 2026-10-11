local build             = import '../build/base.jsonnet';
local baseVerifyBranch  = import '../pipelines/baseVerifyBranch.jsonnet';
local baseVerifyMain    = import '../pipelines/baseVerifyMain.jsonnet';
local generate          = import '../pipelines/hidGenerate.jsonnet';
local publishWebsite    = import '../pipelines/publishHiDWebsite.jsonnet';
local trigger           = import '../drone/trigger.jsonnet';

{
    new(domaintag,registry,containerfile):: self + build.new()
                 .withPipelines([
                     baseVerifyBranch.new(),
                     baseVerifyMain.new(),
                     generate.new()

                 ])
                 .withFinishPipelines([
                     publishWebsite.new("nginx",domaintag,registry,containerfile).withTrigger(trigger.new() + trigger.withBranch("main"))
                 ])


}
