local pipeline          = import '../drone/pipeline.jsonnet';
local gitSteps          = import '../steps/git.jsonnet';
local emptyStep         = import '../steps/empty.jsonnet';
local latex             = import '../steps/latexPaperMakefile.jsonnet';
local when              = import '../drone/when.jsonnet';

{
        new():: pipeline.new()
                .withName("Build Latex Document")
                .withSteps([
                        
                        gitSteps.checkoutSubmodules().withName("CheckoutSubmodules"),
                        latex.withName("Build-Latex-Document").withDependsOn(["CheckoutSubmodules"]),
                        emptyStep.new("LastStep").withDependsOn([
                                "Build-Latex-Document"
                        ]),
                    ])
}