local step = import '../../drone/step.jsonnet';


local msgTags(msg) =
  if std.objectHas(msg, "tags") then
    "," + msg.tags;



local tags(msg) =

  if std.extVar("DRONE_BUILD_STATUS") == "success" && msg.status then
   "heavy_check_mark" + msgTags(msg)
  else
  if std.extVar("DRONE_BUILD_STATUS") == "failure" && msg.status then
   "warning" + msgTags(msg);



{
    new(ntfyserver, ntfymsg):: step.new("ntfy-notification", "docker.io/alpine/curl:latest")
    .withCommands(
                [
                  'if [ "${DRONE_BUILD_STATUS}" == "success" ]; then export TAGS="heavy_check_mark' + msgTags(ntfymsg) + '"; elif [ "${DRONE_BUILD_STATUS}" == "failure" ]; then export TAGS="heavy_check_mark' + msgTags(ntfymsg) + '"; else export TAGS="question' + msgTags(ntfymsg) + '"; fi; '
                  + 'curl '
                    + '-H "Authorization: Bearer ' + ntfyserver.token + '" '
                    + (if std.objectHas(ntfymsg, "title") then ' -H "X-Title: ' + ntfymsg.title + '"' else '')
                    + (if std.objectHas(ntfymsg, "prio") then ' -H "X-Priority:' + ntfymsg.prio + '"' else '')
                    + ' -H "X-Tags: $${TAGS}"'
                    + (if std.objectHas(ntfymsg, "click") then ' -H "Click:' + ntfymsg.click + '"' else '')
                    + (if std.objectHas(ntfymsg, "icon") then ' -H "Icon:' + ntfymsg.icon + '"' else ' -H "Icon: https://cdn.jsdelivr.net/gh/selfhst/icons/png/drone-ci.png"')
                    + ' -d "' + ntfymsg.msg + '"'
                    + " " + ntfyserver.url + "/" + ntfymsg.topic
                ]
                )
}
