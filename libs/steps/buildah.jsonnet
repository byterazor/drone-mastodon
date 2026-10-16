local step = import '../drone/step.jsonnet';

{
    new(image, build, push=true):: step.new("Container-Build", "quay.io/buildah/stable")
                .withPrivileged()
                .withCommands(
                            [
                              "buildah bud -f " +build.containerfile + " -t " +build.cache.url + build.cache.path + "/" + image.name + ":" + image.tags[0],
                              if push then
                                "buildah push --all " + build.cache.url + build.cache.path + "/" + image.name + ":" + image.tags[0]
                            ]
                )



}
