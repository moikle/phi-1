# Phi

# Overview

Takes as input a time series of values (importance or excitation values
for example) and returns a time series of estimated Tononi Phi values.

Author: Matthew Iklé

# How to run

cd to the root project dir and build Docker container:

```
./build-image.sh
```

Run Docker container

```
./run-container.sh
```

Inside the container, cd to `src/` and run `main.py`

```
/opt/singnet/phi/$ cd src
/opt/singnet/phi/src$ python3 main.py
```

# Main files

Phi/
│
├── .git
├── binner.py
├── build_hash.py
├── cal_p_current.py
├── main.py
├── partition.png
├── phi_params.py
├── README.md
├── Sophia_Meditation.csv
├── Sophia_Meditation_cleaned.csv
├── Sophia_Meditation_cleaned2.csv
└── tuple_time_series.py

binner.py:           
    Returns an array of the same size with values replaced by appropriate bin numbers.
    Bin ranges are found as ((SERIES_MAX - SERIES_MIN)/ num_of_bins) * BIN_NUMBER + SERIES_MIN   

build_hash.py:  
    Checks to make sure the time series has produced correct values

cal_p_current.py:   
    Contains most of the necessary function machinery for calculating the appropriate probabilities for use in each graph bi-partition
    This file produces the distributions Pe/c(X{t_or_t-1}|X{t_or_t-1}) = X needed as shown in partition.png
    
main.py:            
    "python main.py" begins the Phi pipeline. There are multiple helper functions for the main run_phi function.
    
partition.png:
    This diagram illustrates the graph "effect repertoire" partition [[(0,1),(1,2)],[(2,),(0,)]] in which nodes 0 and 1 affect nodes 1 and 2, while node 2 affects node 0

phi_params.py:  This is the  file for setting basic parameters including

    int_len, which is the desired length of the sliding window used. The code calculates new
        Phi values across each window, allowing one to see how Phi varies over time.
    
    num_of_bins is the number of bins into which the time-series values for each node is binned
    
    num_of_nodes initializes the number of nodes/features used to calculate Phi. An example graph partition
        can be viewed in the file partition.png.
        
    input_file: is the name of the input file of the time-series data. Each row corresponds to a time step, and each column to 1-D time-series

    no_of_cols_to_skip: is the number of columns to skip in reading in the data from the input file.

    delim is the delimiter used for reading in csv or tsv files

    sliding_window_start is the row in which the first sliding time window starts (1-based so 1 would be the very first row)

README.md:
    This file
    
Sophia_Meditation.csv:
    Example input file, based upon the Sophia Meditation experiment run by Eddie Monroe and Julia Mossbridge. Data supplied by Misgana Bayetta. Running Phi should result in zero at all times since pertitioning off a node that is always zero will result in the same information content.
    
Sophia_Meditation_cleaned.csv:
    This is the same as the Sophia_Meditation.csv file but with the columns consisting of only zeros deleted. With some parameter settings this will still result in a flat zero line.
    
Sophia_Meditation_cleaned2.csv:
    This is the same as the Sophia_Meditation_cleaned.csv file but with the columns consisting of only one non-zero value deleted.
    
# What is Tononi Phi?

Created by University of Wisconsin psychiatrist and neuroscientist Giulio Tononi in
2004, Integrated Information Theory (IIT) is an evolving system and calculus for
studying and quantifying consciousness. Its centerpiece is Phi, Tononi’s
mathematical quantifier [1, 2].

# Issues in calculating Phi

In calculating Tononi Phi values, three major issues arise

    1)  There are at least 420 choices one can make in calculating the measure [3];
    
    2)  Determination of the “Minimum Information Partition” (MIP) of the causal
        graph structure grows super-exponentially with the number of nodes;
    
    3)  and the size of the probability distribution vectors required to determine
        Phi also increases super-exponentially with the number of nodes. 
    
# Queyranne's Algorithm    

Depending upon the number of features (nodes), we have implemented  two 
approaches for determining the MIP: brute force and Queyranne's algorithm. 
The brute force approach grows super-exponetially in both space and time complexity,
and hence is only practical for small numbers of features. To overcome this 
limitation, we have also chosen to implement Phi 3.0 [4] employing Queyranne’s 
Algorithm [5] to obtain a good approximation of the MIP. More specifically, we used 
the method of Krohn and Ostwald [6] as it applies to time series.  We also stored 
the (often sparse) probability distributions using Python dictionaries instead of 
arrays. Our experiments demonstrate that the two implementations provide identical
partitions for small numbers of nodes.

Queyranne's Algorithm is a graph theoretic algorithm that solves the
MIP/Max Transport Problem for submodular set functions. Although
Phi calculations are not submodular, Kitazono, Kanai, and Oizumi [3, 7, 8] (Araya 
group) empirically demonstrated that Queyranne’s algorithm efficiently finds 
approximation to MIP in the context of the 𝚽* (mismatched decoding) phi 
approximation.

Although similar results appear to hold for Phi 3.0, we have not yet conclusively 
demonstrated, through exhaustive experimentation, that this is indeed the case.

Since even Queyranne's algorithm grows as the cube of the number of nodes, we
include sklearn Independent Component Analysis (ICA) implementations that can be
used as preprocessing steps to reduce the feature dimensionality.

# References

[1] Tononi, G.: Consciousness as integrated information: a provisional manifesto. The Biological Bulletin 215(3), 216–242 (December 2008)

[2] Tononi, G.: An information integration theory of consciousness. BMC
Neuroscience 5(1), 42 (2004). https://doi.org/10.1186/1471-2202-5-42,
http://www.biomedcentral.com/1471-2202/5/42

[3] Tegmark, M.: Improved measures of integrated information. PLOS Computational
Biology 12(11), 1–34 (11 2016). https://doi.org/10.1371/journal.pcbi.1005123,
https://doi.org/10.1371/journal.pcbi.1005123

[4] Kitazono, J., Oizumi, M.: Practical PHI Toolbox
(9 2018). https://doi.org/10.6084/m9.figshare.3203326.v10,
https://figshare.com/articles/phi toolbox zip/3203326

[5] https://dl.acm.org/doi/pdf/10.5555/313651.313669

[6] Krohn, S., Ostwald, D.: Computing integrated information. Neuroscience
of Consciousness 2017(1), nix017 (2017). https://doi.org/10.1093/nc/nix017,
http://dx.doi.org/10.1093/nc/nix017

[7] Oizumi,M.,Amari,S.,Yanagawa,T.,Fujii,N.,Tsuchiya,N.:Measuring integrated
information from the decoding perspective. PLoS Comput Biol 12(1), e1004654
(2016). https://doi.org/10.1371/journal.pcbi.1004654

[8] Jun Kitazono, Ryota Kanai, Masafumi Oizumi, "Efficient Algorithms for Searching the Minimum Information Partition in Integrated Information Theory," Entropy 2018, 20(3), 173; https://doi.org/10.3390/e20030173
