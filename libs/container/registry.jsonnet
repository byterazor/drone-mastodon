local base = {
    new(url):: self.withUrl(url) + self.withoutAuth().withPath(""),
    withUrl(url):: self + { url: url },
    withPath(path):: self + {path: path},
    withAuth() :: self + {auth: true},
    withoutAuth():: self + {auth: false},
    withUsername(username):: self + {username: username},
    withPassword(password):: self + { password: password}
};


base
