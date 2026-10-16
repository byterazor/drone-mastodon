local droneStd = import '../drone/std.jsonnet';
local secret   = import '../drone/secret.jsonnet';

local base = {
    new(url):: self.withUrl(url) + self.withoutAuth().withPath(""),
    withUrl(url):: self + { url: url },
    withPath(path):: self + {path: path},
    withAuth() :: self + {auth: true},
    withoutAuth():: self + {auth: false},
    withUsernamePassword(username,password):: self.withAuth() + {username: username, password: password},
    withUsernameSecret(secret)::
      self + {usernameSecret: secret},
    withPasswordSecret(secret)::
        self.withAuth() + {passwordSecret: secret},
    withK8sCredentials(userSecret, passwordSecret):: self
      .withUsernameSecret(userSecret)
      .withPasswordSecret(passwordSecret),
    loginCommand()::
          if std.objectHas(self,'passwordSecret') then
            "buildah login -u $" + std.asciiUpper(self.usernameSecret.name) + " -p $" + std.asciiUpper(self.passwordSecret.name) + " " + self.url
          else
            "buildah login -u " + self.username + " -p " + self.password + " " + self.url,
};

base
