local base = {
    new(url):: self.withUrl(url) + self.withoutAuth(),
    withUrl(url):: self + { url: url },
    withAuth() :: self + {auth: true},
    withoutAuth():: self + {auth: false},
    withUsername(username):: self + {username: username},
    withPassword(password):: self + { password: password}
};


base
