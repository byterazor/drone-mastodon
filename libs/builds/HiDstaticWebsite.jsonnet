local build             = import '../build/base.jsonnet';
local containerImage    = import '../container/image.jsonnet';
local baseVerifyBranch  = import '../pipelines/baseVerifyBranch.jsonnet';
local baseVerifyMain    = import '../pipelines/baseVerifyMain.jsonnet';
local generate          = import '../pipelines/hidGenerate.jsonnet';
local publishWebsite    = import '../pipelines/publishHiDWebsite.jsonnet';
local publishManifest   = import '../pipelines/publishContainerManifest.jsonnet';
local trigger           = import '../drone/trigger.jsonnet';
local platform          = import '../drone/platform.jsonnet';
local when              = import '../drone/when.jsonnet';

{
    new(containerBuild):: self + build.new()
                 .withPipelines([
                     baseVerifyBranch.new(), // check everything commit related on current branch
                     baseVerifyMain.new(),   // check everything commit related on main branch, if build for main branch
                     generate.new()          // check if we can build the website
                 ]
                 +
                 [
                      // we have to split the pipelines here depending on architecture
                      publishWebsite.new(containerImage.new(containerBuild.manifest.name)
                                                       .withTags(containerBuild.manifest.tags[0] + "-" + arch) , containerBuild)
                                    .withPlatform(platform.new("linux", arch))
                                    .withName("Build-Image-" + containerBuild.manifest.name + "-" + arch)
                                    .withDependsOn([
                                        "VerifyCommits",
                                        "VerifyCommitsOnMainBranch",
                                        "HiD-Generate"
                                    ])
                                    .withTrigger(trigger.new()+ trigger.withBranch("main") + trigger.withStatus("success") + trigger.withEvent(["push"]))
                      for arch in containerBuild.manifest.archs
                 ]
                 )
                 .withFinishPipelines(
                 [
                  publishManifest.new(containerBuild).withDependsOn(
                    [
                    "Build-Image-" + containerBuild.manifest.name + "-" + arch
                    for arch in containerBuild.manifest.archs
                    ]
                  ).withTrigger(trigger.new()+ trigger.withBranch("main") + trigger.withStatus("success") + trigger.withEvent(["push"]))
                 ]

                 )
}
