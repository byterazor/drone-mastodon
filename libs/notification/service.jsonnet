local base = {

  new():: {} + self,
  withToken(token):: self + {token: token},
  withUsername(username):: self + {username: username},
  withPassword(password):: self + {password: password},
  withUrl(url):: self + {url: url}
};

base
