# Examples

* [simple (no `build.yaml`)](https://github.com/dartsidedev/build_pubspec/tree/master/example/simple)
* [custom output Dart file](https://github.com/dartsidedev/build_pubspec/tree/master/example/custom_output)
* [custom fields (rename fields in the output file)](https://github.com/dartsidedev/build_pubspec/tree/master/example/custom_fields)
* [use source_gen and create a `.pubspec.g.dart` part file](https://github.com/dartsidedev/build_pubspec/tree/master/example/part_g)

## How to run the examples

1. `cd example/{SELECT_YOUR_EXAMPLE}`
2. `pub get`
3. `pub run build_runner build`

I didn't add the generated files to `.gitignore` in the example folders so
that you can see the expected output even without running the examples.
However, you can consider adding generated files to `.gitignore` in your project.
