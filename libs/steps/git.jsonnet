local step = import '../drone/step.jsonnet';



{
    clone(url):: step.new("Clone Repository", "alpine/git").withCommands(["git clone " + url + " ."]),
    updateSubmoduleToCommit(path, commit):: step.new("Update Submodule to Commit", "alpine/git").withCommands([
                                                        'cd ' + path,
                                                        'git checkout ' + commit,
                                                    ]),
    checkoutSubmodules():: step.new("Submodule Checkout", "alpine/git")       .withCommands([
                    'git submodule update --init --recursive',
                ]),
    checkoutMain():: step.new("Checkout main branch", "alpine/git")
                .withCommands([
                    'git fetch origin main',
                    'git remote set-head origin main',
                ])
}
