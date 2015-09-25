# conceptr

Concept hierarchies are common in all kinds of knowledge areas and applications
of statistics. And they can be deceptively simple, or perhaps, annoyingly
difficult to deal with.

This package was made with a different concept hierarchy in mind, that of 
Palynofacies data. The basic ideas however, should be the same where we need to
work with data that is presented as multilevel classes, or presents multilevel
features. This package hopes to help you when you need to work with these kinds
of data by allowing you to visualize the hierarchies themselves, but also to
check the data agains the hierarchies and allow operations such as aggregation
by level or aggregation by (super) class.

## Installation
The package is still far from complete, so please be mindful of errors if you
are going to use this. By all means report the issues that you find so that I
can fix them.

    devtools::install_github("fvd/conceptr")

## Usage


## Features


## Example data

There is a small example data set included that you can compare to your own.
Please note that you must use R-style names (no spaces, no non-ascci) for the
column names in the data file. The package will `make.normal` any names that it
will find.

Load the test data from the inst folder in the package:

    data <- read.csv(system.file("data.csv", package="conceptr"))
    hierarchy <- read.csv(system.file("concept-hierarchy.csv", package="conceptr"))
 
