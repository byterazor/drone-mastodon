local step = import '../drone/step.jsonnet';

{
    new(build):: step.new("Build-Manifest", "quay.io/buildah/stable")
                .withPrivileged()
                .withEnv(build.registriesEnvironment())
                .withCommands([
                              "buildah manifest create " + build.manifest.name + ":"+ build.manifest.tags[0]
                              ]
                              +
                              [
                                "buildah manifest add " + build.manifest.name + ":"+ build.manifest.tags[0] + " " + build.cache.url + build.cache.path + "/" + build.manifest.name + ":" + build.manifest.tags[0] + "-" + arch
                                for arch in build.manifest.archs
                              ]
                              +
                              [

                                 (
                                 if r.auth then
                                  r.loginCommand() + ";" + "buildah manifest push --all " + build.manifest.name + ":" + build.manifest.tags[0] + " " + r.url + r.path + "/" + build.manifest.name + ":" + tag
                                 else
                                 "buildah manifest push --all " + build.manifest.name + ":" + build.manifest.tags[0] + " docker://" + r.url +  r.path + "/" + build.manifest.name + ":" + tag
                                 )
                                 for tag in build.manifest.tags
                                 for r in build.registries
                              ]
                            ),
}
