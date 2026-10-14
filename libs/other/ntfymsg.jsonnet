local base = {
    new():: {} + self.withStatus() ,
    withTopic(topic):: self + {topic: topic},
    withMsg(msg):: self + {msg: msg},
    withTitle(title):: self + {title: title},
    withPriority(prio):: self + {prio: prio},
    withTags(tags):: self + {tags: tags },
    withClick(click):: self + {action: click},
    withIcon(icon):: self + {icon: icon},
    withStatus():: self + {status: true},
    withoutStatus():: self + {status: false}
};


base
