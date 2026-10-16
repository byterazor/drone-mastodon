local message = import '../message.jsonnet';
local step    = import '../../drone/step.jsonnet';

local tags2Str(tags) =
  std.foldl(
    function(acc, tag)
      if acc == '' then tag
      else acc + ',' + tag,
    tags,
    '',
  );


local msgTags(msg) =
  if std.objectHas(msg, "tags") then
    if msg.status then "," + tags2Str(msg.tags) else
      tags2Str(msg.tags)
  ;


{
  new(service):: self + message.new(service),
  withTopic(topic):: self + {topic: topic},
  withPriority(prio):: self + {prio: prio},
  withClick(click):: self + {action: click},
  render():: [
      step.new("ntfy-notification", "docker.io/alpine/curl:latest")
      .withCommands(
                  [
                    'if [ "${DRONE_BUILD_STATUS}" == "success" ]; then export TAGS="heavy_check_mark' + msgTags(self) + '"; elif [ "${DRONE_BUILD_STATUS}" == "failure" ]; then export TAGS="warning' + msgTags(self) + '"; else export TAGS="question' + msgTags(self) + '"; fi; '
                    + 'curl '
                      + '-H "Authorization: Bearer ' + self.service.token + '" '
                      + (if std.objectHas(self, "title") then ' -H "X-Title: ' + self.title + '"' else '')
                      + (if std.objectHas(self, "prio") then ' -H "X-Priority:' + self.prio + '"' else '')
                      + ' -H "X-Tags: $${TAGS}"'
                      + (if std.objectHas(self, "click") then ' -H "Click:' + self.click + '"' else '')
                      + (if std.objectHas(self, "icon") then ' -H "Icon:' + self.icon + '"' else ' -H "Icon: https://cdn.jsdelivr.net/gh/selfhst/icons/png/drone-ci.png"')
                      + ' -d "' + self.message + '"'
                      + " " + self.service.url + "/" + self.topic
                  ]
                  )
  ]
}
