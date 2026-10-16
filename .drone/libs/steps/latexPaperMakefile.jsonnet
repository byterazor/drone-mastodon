local step = import '../drone/step.jsonnet';


step.new("Build Latext", "kmaster.ti.unibw-hamburg.de:30808/latex:latest").withCommands([
                            "make"
                            ])