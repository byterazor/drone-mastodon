local step = import '../drone/step.jsonnet';




{
    new(action):: step.new("Check Commit Message", "byterazor/drone-commitlint:dev")
                                                        .withSettings({
                                                            ACTION: action
                                                        })
   
}