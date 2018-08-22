# Toy Robot Simulator

## Description

This is a simulation of a toy robot moving on a square tabletop, of dimensions 5 units x 5 units.

## Dependencies

* Ruby 2.0.x-2.5.x

## Installation

```
$ gem install bundler && bundle install
```

## Running The Application

### With Defaults From The Repository Root

```
$ ruby bin/trs
```

### Defaults

A random file in ./programs (relative to this README) is selected.

### Optional Switches

* `-d, --directory, --programs_directory` The directory where programs can be found.  Defaults to `./programs` (relative to this README).
* `-p, --program` The name of the program to run as it is in the filesystem.  Defaults to a random program in the programs directory.

## Running The Tests

```$ ruby test/all.rb```
