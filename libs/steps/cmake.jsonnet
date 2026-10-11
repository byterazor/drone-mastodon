local step = import '../drone/step.jsonnet';

{
    new(build_image,build_type,concurrency,runTest):: step.new("CMake-Build", build_image)
                .withCommands([
                            "mkdir build && cd build",
                            "cmake -DCMAKE_BUILD_TYPE="+build_type+" ..",
                            "make -j " + concurrency,
                            if runTest then "make test" else "echo \"no tests\""
                            ])

}