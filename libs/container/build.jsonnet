

local base = {
    new(manifest):: {} + self.withContainerFile("Containerfile")
                        .withDirectory(".")
                        .withManifest(manifest),
    withContainerFile(containerfile):: self + {containerfile: containerfile},
    withDirectory(directory):: self + {directory: directory},
    withManifest(manifest):: self + {manifest: manifest},
    withRegistries(registries):: self + if std.type(registries) == 'array' then { registries: registries } else { registries: [registries] },
    withCacheRegistry(cache)::self + {cache: cache},
    registrySecrets()::
      local regs = if std.objectHas(self,'registries') then self.registries else [];
      local flat = [d for r in regs
                    for d in (if std.objectHas(r,'usernameSecret') then [r.usernameSecret] else [])
                             + (if std.objectHas(r,'passwordSecret') then [r.passwordSecret] else [])];
      flat,
    registriesEnvironment()::
            { [std.asciiUpper(s.name)]: {from_secret: s.name} for s in self.registrySecrets() }

};

base
