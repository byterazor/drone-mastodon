local build             = import '../build/base.jsonnet';
local containerImage    = import '../container/image.jsonnet';
local baseVerifyBranch  = import '../pipelines/baseVerifyBranch.jsonnet';
local baseVerifyMain    = import '../pipelines/baseVerifyMain.jsonnet';
local generate          = import '../pipelines/hidGenerate.jsonnet';
local buildContainer    = import '../pipelines/buildContainerImage.jsonnet';
local publishManifest   = import '../pipelines/publishContainerManifest.jsonnet';
local trigger           = import '../drone/trigger.jsonnet';
local platform          = import '../drone/platform.jsonnet';
local when              = import '../drone/when.jsonnet';

{
    new(containerBuild):: self + build.new()
                 .withSecrets(containerBuild.registrySecrets())
                 .withPipelines([
                     baseVerifyBranch.new(), // check everything commit related on current branch
                     baseVerifyMain.new(),   // check everything commit related on main branch, if build for main branch
                 ]
                 +
                 [
                      // we have to split the pipelines here depending on architecture
                      buildContainer.new(containerImage.new(containerBuild.manifest.name)
                                                       .withTags(containerBuild.manifest.tags[0] + "-" + arch) , containerBuild, false)
                                    .withPlatform(platform.new("linux", arch))
                                    .withName("Test-Image-" + containerBuild.manifest.name + "-" + arch)
                                    .withDependsOn([
                                        "VerifyCommits",
                                        "VerifyCommitsOnMainBranch",
                                    ])
                      for arch in containerBuild.manifest.archs
                 ]
                 +
                 [
                      // we have to split the pipelines here depending on architecture
                      buildContainer.new(containerImage.new(containerBuild.manifest.name)
                                                       .withTags(containerBuild.manifest.tags[0] + "-" + arch) , containerBuild, true)
                                    .withPlatform(platform.new("linux", arch))
                                    .withName("Build-Image-" + containerBuild.manifest.name + "-" + arch)
                                    .withDependsOn([
                                        "VerifyCommits",
                                        "VerifyCommitsOnMainBranch",
                                    ]
                                    )
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
