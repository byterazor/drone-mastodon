local step = import '../drone/step.jsonnet';


step.new("Check for Password leaks", "zricethezav/gitleaks:latest").withCommands([
                            "gitleaks detect"
                            ])