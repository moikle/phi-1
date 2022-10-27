int_len = 20 # This is the desired length of the sliding window used. The code calculates new
             # Phi values across each window, allowing one to see how Phi varies over time.
num_of_bins = 5 # bins the time-series data for each node into num_of_bins bins
num_of_nodes = 69
#initializes the number of nodes/features used to calculate Phi. Example graph partitions can be viewed in the files. If Independent Component Analysis (ICA) is turned on, this number will be recomputed on the fly, based upon the dimensional reduction from sk-learn's ICA routine."""
input_file = '../Sophia_Meditation_cleaned2.csv'
no_of_cols_to_skip = 0
delim = ","
sliding_window_start = 1

