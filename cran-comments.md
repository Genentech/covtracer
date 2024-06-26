> Examples with CPU (user + system) or elapsed time > 5

Some examples (roughly 4, depending on CPU speed) take just slightly over 5s to
run. We've taken a lot of care to make them run as fast as possible, but due to
the nature of the package, having meaningful examples that showcase the breadth
of edge cases requires running `covr::package_coverage` against an embedded
example package. This is inevitably a bottleneck for any sizable package.
The slow example times are surely tolerable to any users of the package as
real-world use cases will be far longer test suites.
