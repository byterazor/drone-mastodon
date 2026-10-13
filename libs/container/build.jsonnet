

local base = {
    new(manifest):: {} + self.withContainerFile("Containerfile")
                        .withDirectory(".")
                        .withManifest(manifest),
    withContainerFile(containerfile):: self + {containerfile: containerfile},
    withDirectory(directory):: self + {directory: directory},
    withManifest(manifest):: self + {manifest: manifest},
    withRegistries(registries):: self + if std.type(registries) == 'array' then { registries: registries } else { registries: [registries] },
    withCacheRegistry(cache)::self + {cache: cache}
};

base
