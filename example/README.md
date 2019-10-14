# `build_pubspec` example

> Maintained by *Vince Varga* - https://dartside.dev

## How to run this example

```
$ cd example
$ pub get
$ pub run build_runner build
[INFO] Generating build script completed, took 302ms
[INFO] Creating build script snapshot... completed, took 10.0s
[INFO] Building new asset graph completed, took 638ms
[INFO] Checking for unexpected pre-existing outputs. completed, took 1ms
[INFO] Running build completed, took 57ms
[INFO] Caching finalized dependency graph completed, took 40ms
[INFO] Succeeded after 107ms with 1 outputs (1 actions)

### This output should change once I update the library...
$ cat lib/src/version.dart
// Generated code. Do not modify.
const packageVersion = '0.1.2';

## Don't forget to tell pub to fetch the latest version of the local package
## if something strange is going on. I'm not sure it's needed or if it's the solution
$ pub cache repair
```
