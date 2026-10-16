local pipeline          = import '../drone/pipeline.jsonnet';
local gitSteps          = import '../steps/git.jsonnet';
local emptyStep         = import '../steps/empty.jsonnet';
local hid               = import '../steps/hid.jsonnet';
local buildahManifest   = import '../steps/buildah-manifest.jsonnet';
local when              = import '../drone/when.jsonnet';

{
        new(build):: pipeline.new()
                .withName("Publish-Static-Website")
                .withoutClone()
                .withSteps([
                        buildahManifest.new(build)
                    ])
}
