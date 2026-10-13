local pipeline          = import '../drone/pipeline.jsonnet';
local gitSteps          = import '../steps/git.jsonnet';
local emptyStep         = import '../steps/empty.jsonnet';
local hid               = import '../steps/hid.jsonnet';
local buildah           = import '../steps/buildah.jsonnet';
local when              = import '../drone/when.jsonnet';

{
        new(image,build):: pipeline.new()
                .withName("Publish-Static-Website-" + image.name + ":" + image.tags[0])
                .withSteps([
                        gitSteps.checkoutSubmodules().withName("CheckoutSubmodules"),
                        hid.withName("Generate-HiD").withDependsOn(["CheckoutSubmodules"]),
                        buildah.new(image, build).withDependsOn(["Generate-HiD"])
                    ])
}
