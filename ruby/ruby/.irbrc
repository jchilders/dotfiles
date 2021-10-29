# Use Pry as console if found in load path, otherwise use stock irb
Pry.start || exit rescue LoadError
