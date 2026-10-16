local base = {

  new(service):: {} + self.withoutStatus().withService(service),
  withService(service):: self + {service: service},
  withMessage(message):: self + {message: message},
  withStatus():: self + {status: true},
  withoutStatus():: self + {status: false},
  withTags(tags):: self + {tags: tags},
  withIcon(url):: self + {iconUrl: url},
  withTitle(title):: self + {title: title},

};

base
