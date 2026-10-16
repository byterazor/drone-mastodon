local base = {
    new():: self + {},
    withUrl(url):: self + {url: url},
    withToken(token):: self + {token: token}
};


base
