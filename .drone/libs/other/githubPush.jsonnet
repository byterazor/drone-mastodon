local step = import '../drone/step.jsonnet';

{
  new(username, token):: {} + self.withUsername(username).withToken(token),
  withUsername(username):: self + {username: username},
  withToken(tokensecret):: self + {token: tokensecret},
  withRepoName(name):: self + {reponame: name},
  withDescription(desc):: self + {description: desc},
  withHomepage(url):: self + {url: url},
  push()::
    local repo = self.username + "/" + self.reponame;
    local desc = self.description;
    local token = self.token;
    local url = self.url;
    step.new("github_push","registry.cloud.federationhq.de/drone-github-mirror:latest")
            .withSettings({
                GH_TOKEN: {
                  from_secret: token.name
                },
                GH_REPO: repo,
                GH_REPO_DESC: desc,
                GH_REPO_HOMEPAGE: url
            })
}
