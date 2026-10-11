local step = import '../drone/step.jsonnet';

{
    new(imageName, tag, registry, containerfile):: step.new("Container-Build", "quay.io/buildah/stable")
                .withPrivileged()
                .withCommands([
                            "buildah bud -f " +containerfile + " -t " +registry + "/" + imageName + ":" + tag,
                            "buildah push --all " + registry + "/" + imageName + ":" + tag
                            ])

}
