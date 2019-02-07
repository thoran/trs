# Toy Robot Simulator

## Description

This is a simulation of a toy robot moving on a square tabletop of dimensions 5 units x 5 units.

## Dependencies

* Ruby 2.0.x-2.6.x

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

```
$ ruby test/all.rb
```

## Design

I've taken a look around at numerous solutions to this problem and my solution is different from any of the others.
For instance, it is the only one which uses the observer pattern.  Does that make is better, worse, or merely
different?  Let's take a look...

It could be argued that my solution is too complicated, that there's too much coupling, or that it is less
space-efficient than it could be for making use of a data structure to store the position of the robot rather than
simply storing the x,y co-ordinates in the robot itself alone.  As I have refined this I have removed a lot of the
complexity, some of which was more necessary than others, a few of the errors which while they didn't affect the
functionality, did affect the readability of the solution.

The idea I had in mind when I created this was to have a robot which wasn't merely a token on a board, but rather
had the capacity to operate itself at some level.  This is why the robot has the board and the instructions loaded
into it.  After initialization it merely receives a tick and it does the rest, interrogating its copy of the
tabletop to be sure of it's next move and interpreting the instructions itself rather than being told where to
move.  And finally, once the robot has moved it informs the umbrella code (the ToyRobotSimulator class) and that in
turn updates the tabletop.

So, perhaps it would help to know some of the rationale for at how the solution was arrived.  When I first wrote this
I over-did it.  I created a solution which parameterised everything, such that one could have an n-dimensional space,
arbitrary size axes, and any number of robots.  In this context I decided it was easier, though less space efficient,
to create an n-dimensional array to store robot locations in the tabletop than it was to interrogate each robot via
use of Ruby's ObjectSpace or via registration of robots in a class instance variable in the ToyRobot class so as to
be able to figure out where a robot could move to given the assumption of 1 robot per tuple in the n-dimensional
array and in order to make the job of outputting the current state of the array slightly easier.

It's also difficult with coding exercises to adjudge as to when something is too much or too little.  Obviously my
earlier design with parameterized everything was too much and I was having fun doing a little extra to show-off.
Other coding exercises I've attempted to return the solution as quickly as possible whilst going for something akin
to code golf.  The brevity wasn't valued but considered a poor design.  Since when was a small coding exercise ever
going to be 'enterprisey'?  It's hard to know what people want.

For instance, while I may yet do it, I have chosen not to split out each of the commands into their own class
even if it might demonstrate good design, since it might also be seen as an an unnecessary contrivance.  Which is
correct?

I have started down the process of creating a branch for each of the other significantly different versions of this.
Still missing is an even simpler version.
