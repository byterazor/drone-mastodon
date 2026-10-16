local containerManifest = import '.drone/libs/container/manifest.jsonnet';
local containerBuild = import '.drone/libs/container/build.jsonnet';
local containerRegistry = import '.drone/libs/container/registry.jsonnet';
local build = import '.drone/libs/builds/ContainerImageBuild.jsonnet';
local secret = import '.drone/libs/drone/secret.jsonnet';

local dockerUsernameSecret = secret.new("docker-username","docker","username");
local dockerPasswordSecret = secret.new("docker-password","docker","password");


local fedhqRegistry = containerRegistry.new("registry.cloud.federationhq.de");
local dockerRegistry = containerRegistry.new("registry.hub.docker.com").withPath("/byterazor").withAuth().withK8sCredentials(dockerUsernameSecret,dockerPasswordSecret);

local manifest = containerManifest.new("drone-mastodon").withTags(["latest"])
                                             .withArchs(["amd64","arm64"]);

local myBuild = containerBuild.new(manifest).withRegistries([fedhqRegistry,dockerRegistry])
                                             .withCacheRegistry(fedhqRegistry);


build.new(myBuild).withSecrets(
                                  [
                                    secret.new("DOCKER_USERNAME","docker","username"),
                                    secret.new("DOCKER_PASSWORD","docker","secret")
                                  ]
                                )
                                .render()
