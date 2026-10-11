local pipeline          = import '../drone/pipeline.jsonnet';
local gitSteps          = import '../steps/git.jsonnet';
local emptyStep         = import '../steps/empty.jsonnet';
local gpgStep           = import '../steps/gpg.jsonnet';
local commitlintStep    = import '../steps/commitlint.jsonnet';
local gitleaks          = import '../steps/gitleaks.jsonnet';
local when              = import '../drone/when.jsonnet';

{
        new():: pipeline.new()
                .withName("VerifyCommits")
                .withSteps([

                        gitSteps.checkoutSubmodules().withName("CheckoutSubmodules"),
                        gitSteps.checkoutMain().withName("CheckoutMainBranch").withDependsOn(["CheckoutSubmodules"]),
                        gpgStep.new().withName("Check-For-GPGSignatures").withDependsOn(["CheckoutMainBranch"]),
                        commitlintStep.new("branch-commits").withName("Check-Commit-Messages").withDependsOn(["CheckoutMainBranch"]),
                        gitleaks.withName("Check-For-Credentials").withDependsOn(["CheckoutSubmodules"]),
                        emptyStep.new("LastStep").withDependsOn([
                                "Check-For-Credentials",
                                "Check-Commit-Messages",
                                "Check-For-GPGSignatures"
                        ]),
                    ])
}
