local pipeline          = import '../drone/pipeline.jsonnet';
local gitSteps          = import '../steps/git.jsonnet';
local emptyStep         = import '../steps/empty.jsonnet';
local hid               = import '../steps/hid.jsonnet';
local when              = import '../drone/when.jsonnet';

{
        new():: pipeline.new()
                .withName("HiD-Generate")
                .withSteps([

                        gitSteps.checkoutSubmodules().withName("CheckoutSubmodules"),
                        hid.withName("Generate-HiD").withDependsOn(["CheckoutSubmodules"])
                    ])
}
