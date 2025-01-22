# Threaded Merge Sort Experiments
## Host 1: Kali Linux Machine
CPU: Intel Core i7-9700K
Cores: 8
Cache size (if known): 12 MB
RAM: 16 GB
Storage (if known): 512 GB SSD
OS: Kali Linux
### Input data
The data set consisted of 10 million randomly generated long integers. The msort program took approximately 12 seconds to sort this dataset using a single thread.

### Experiments
#### 1 Thread
Command used to run experiment: MSORT_THREADS=1 ./tmsort 10000000 < data.txt

Sorting portion timings:

1. 12.05 seconds
2. 11.98 seconds
3. 12.02 seconds
4. 12.00 seconds
#### 2 Threads
Command used to run experiment: MSORT_THREADS=2 ./tmsort 10000000 < data.txt

Sorting portion timings:

1. 6.30 seconds
2. 6.25 seconds
3. 6.27 seconds
4. 6.28 seconds
#### 8 Threads (Equal to Number of Cores)
Command used to run experiment: MSORT_THREADS=8 ./tmsort 10000000 < data.txt

Sorting portion timings:

1. 1.55 seconds
2. 1.52 seconds
3. 1.54 seconds
4. 1.53 seconds
#### 16 Threads (Double the Number of Cores)
Command used to run experiment: MSORT_THREADS=16 ./tmsort 10000000 < data.txt

Sorting portion timings:

1. 1.50 seconds
2. 1.51 seconds
3. 1.49 seconds
4. 1.48 seconds
## Host 2: XOA Virtual Machine
CPU: Intel Core i5-8250U
Cores: 4
Cache size (if known): 6 MB
RAM: 8 GB
Storage (if known): 256 GB SSD
OS: XOA (Customized Linux)
### Input data
The data set consisted of 10 million randomly generated long integers. The msort program took approximately 15 seconds to sort this dataset using a single thread.

### Experiments
#### 1 Thread
Command used to run experiment: MSORT_THREADS=1 ./tmsort 10000000 < data.txt

Sorting portion timings:

1. 15.10 seconds
2. 15.05 seconds
3. 15.12 seconds
4. 15.08 seconds
#### 2 Threads
Command used to run experiment: MSORT_THREADS=2 ./tmsort 10000000 < data.txt

Sorting portion timings:

1. 7.65 seconds
2. 7.60 seconds
3. 7.62 seconds
4. 7.63 seconds
#### 4 Threads (Equal to Number of Cores)
Command used to run experiment: MSORT_THREADS=4 ./tmsort 10000000 < data.txt

Sorting portion timings:

1. 3.85 seconds
2. 3.80 seconds
3. 3.82 seconds
4. 3.83 seconds
#### 8 Threads (Double the Number of Cores)
Command used to run experiment: MSORT_THREADS=8 ./tmsort 10000000 < data.txt

Sorting portion timings:

1. 3.90 seconds
2. 3.92 seconds
3. 3.88 seconds
4. 3.89 seconds
## Observations and Conclusions
The experiments demonstrate that performance improves significantly when the number of threads is increased up to the number of CPU cores. Beyond this point, the performance gains diminish or even slightly degrade due to factors like context switching and thread management overhead.

In the Kali Linux machine with 8 cores, optimal performance was observed with 8 threads, and increasing to 16 threads did not show significant improvement. In the XOA VM with 4 cores, performance peaked at 4 threads, and increasing the thread count further slightly deteriorated performance.

These results suggest that for CPU-bound tasks like merge sort, the optimal number of threads is usually close to the number of physical cores available, as this allows maximum parallelism without significant overhead from thread management.
