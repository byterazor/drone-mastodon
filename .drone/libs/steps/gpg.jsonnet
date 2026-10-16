local step = import '../drone/step.jsonnet';


{
    new(verify=false):: step.new("GPG Signature Verification", "byterazor/drone-git-signed-commit-check:dev")
                                                        .withSettings({
                                                            MAIN_BRANCH: "main",
                                                             NR_COMMITS: 10
                                                        })
}