local pipeline          = import '../drone/pipeline.jsonnet';
local trigger           = import '../drone/trigger.jsonnet';
local emptyStep         = import '../steps/empty.jsonnet';
local gitSteps          = import '../steps/git.jsonnet';
local gpgStep           = import '../steps/gpg.jsonnet';
local commitlintStep    = import '../steps/commitlint.jsonnet';
local gitleaks          = import '../steps/gitleaks.jsonnet';
local when              = import '../drone/when.jsonnet';

{
    new():: pipeline.new()
        .withName("VerifyCommitsOnMainBranch")
        .withSteps([
                        gitSteps.checkoutSubmodules().withName("CheckoutSubmodules"),
                        gpgStep.new().withName("Check-For-GPGSignatures").withDependsOn(["CheckoutSubmodules"]),
                        commitlintStep.new("last-commit").withName("Check-Commit-Messages").withDependsOn(["CheckoutSubmodules"]),
                        gitleaks.withName("Check-For-Credentials").withDependsOn(["CheckoutSubmodules"]),
                        emptyStep.new("LastStep").withDependsOn([
                                "Check-For-Credentials",
                                "Check-Commit-Messages",
                                "Check-For-GPGSignatures"
                        ]),
                    ])
         .withTrigger(trigger.new() + trigger.withBranch("main"))
}
