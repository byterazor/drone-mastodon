local step = import '../drone/step.jsonnet';

{
    new(image, build):: step.new("Container-Build", "quay.io/buildah/stable")
                .withPrivileged()
                .withCommands(
                            [
                              "buildah bud -f " +build.containerfile + " -t " +build.cache.url + "/" + image.name + ":" + image.tags[0],
                              "buildah push --all " + build.cache.url + "/" + image.name + ":" + image.tags[0]
                            ]
                )



}
