local step = import '../drone/step.jsonnet';

{
    new(name): step.new(name, "alpine/git").withCommands([
                            "echo finished"
                            ])
}