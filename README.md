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
are going to use this. By all means report or fix any issues that you may find.

To install makes sure you have the package `devtools` installed and run:

    devtools::install_github("fvd/conceptr")

## Usage
### Data formats
The library is still primitive and not tested for all possible exceptions. You
can help by reporting any issues you find with your data so that the package
can be made more generic.

At the moment a number of conventions are imposed:

1. The `hierarchy` dataframe has three columns with names `c("id","name",
   "parent_id")`
1. The column names in the `data` dataframe need to match the names in
   `hierarachy$name` 

Note that to match the names in the hierarchy and data dataframes both the
`hierarchy$name` column and column names in `data` will be normalized with
`make.names`.

In the test data we use the following example hierarchy to which we will refer
below in the usage section:

    Level1:      A         B         C      D
                 |         |         |     
    Level2:    AA AB    BA BB BD    CA    
               |                   |
    Level3:   AAA               CAA CAB
                                 |
    Level4:                    CABA


## Features
### Aggregate by name
Aggregate all data from all the sub-levels of a concept by summing the
observations. So in the example `aggregate.byname(D)` returns `D` and
`aggregate.byname(B)` returns `B+BA+BB+BD`. We need to reference the hierarchy
to use so the full example would be:

     aggregate.byname(data, hierarchy, "Level1-D")
 
and

    aggregate.byname(data, hierarchy, "Level1-B")

The full names in the test data base include the levels, so Level1-A, Level2-AA
etc.

### Ternary plots
Make exploratory analysis of the data at different levels easier by plotting by
name. 

    visualize.ternary(data, hierarchy, c("A", "BA", "CAA"))
 
### Planned 

## Example data
There is a small example data set included that you can compare to your own.
Please note that you preferably use R-style names (no spaces, no non-ascci) for
the column names in the data file. The package will `make.normal` any names
that it will find.

To load the test data from the inst folder in the package:

    data <- read.csv(system.file("data.csv", package="conceptr"))
    hierarchy <- read.csv(system.file("concept-hierarchy.csv", package="conceptr"))
 
