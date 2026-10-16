local step = import '../drone/step.jsonnet';

{
    new(build):: step.new("Build-Manifest", "quay.io/buildah/stable")
                .withPrivileged()
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
                                 "buildah login -u " + r.username + " -p " + r.password + " " + r.url + ";" + "buildah manifest push --all " + build.manifest.name + ":" + build.manifest.tags[0] + " " + r.url + build.manifest.path + "/" + build.manifest.name + ":" + tag
                                 else
                                 "buildah manifest push --all " + build.manifest.name + ":" + build.manifest.tags[0] + " docker://" + r.url +  build.manifest.path + "/" + build.manifest.name + ":" + tag
                                 )
                                 for tag in build.manifest.tags
                                 for r in build.registries
                              ]

                              // +
                              // [
                              //   "buildah login -u " + r.username + " -p " + r.password + " " + r.url + ";" + "buildah manifest push --all " + imageName + ":" + tag + r.url + "/" + imageName + ":" + t
                              //   for r in registries
                              //   for t in moreTags
                              // ]
                            ),
}
