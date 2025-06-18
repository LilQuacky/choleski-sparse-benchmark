# Cholesky-Sparse-Benchmark

### Cholesky Decomposition for Sparse Linear Systems: MATLAB vs SciPy

> **University Project – Scientific Computing Methods**
> Authors: *Falbo Andrea*, *Tenderini Ruben*

## Table of Contents

### [Overview](#overview)
### [Repository Structure](#-repository-structure)
### [Tools and Libraries](#-tools-and-libraries)
### [Methodology](#methodology)
### [Run](#run)
### [Key Findings](#key-findings)
### [Authors](#authors)
### [License](#license)

## Overview

This repository contains the code and materials developed for the **Scientific Computing Methods** couse of **Università
degli Studi Milano-Bicocca**. The goal of the project is to:

* Solve large sparse, symmetric, and positive-definite linear systems using the **Cholesky decomposition**.
* Implement the method and compare the performance between a closed-source environment (MATLAB) and an open-source 
alternative (SciPy).
* Evaluate performance on **Windows** and **Linux** environments.

Full project specifications are available in [`specification.pdf`](./specification.pdf) (in Italian).

## Repository Structure

```
├── specification.pdf         <- Project specifications
├── report.pdf                <- Final report (in Italian)
├── matlab/                   <- MATLAB implementation
├── python/                   <- Python implementation using SciPy
│   └── notebooks/            <- Jupyter Notebooks for analysis and plots
├── runs/                     <- Raw CSV results from tests
├── runs_mean/                <- Averaged results from 'runs/'
├── README.md                 <- This file
```

## Tools and Libraries

### MATLAB

* Version: R2024.2.0

### Python

* Version: 3.11.11
* Main libraries:

  * `scipy` 1.15.2
  * `scikit-sparse` 0.4.14

### Operating Systems

* Windows 11
* Ubuntu 24.04.2

## Methodology

For details about:

* Theoretical background (Cholesky factorization, sparse matrices, etc.)
* Programming environments and library choices
* Experimental setup and methodology
* Detailed results and comparative analysis
* Conclusions and future developments
Please refer to the [**final report**](./report.pdf) (in Italian).

## Run

### MATLAB

1. Open MATLAB and navigate to the `matlab/` folder.
2. Run the `runner.m` script.

### Python

1. Create and activate a virtual environment.
2. Install required packages.
3. Run the `main.py` script in the `python/` directory.
4. To generate plots and summaries, open and execute the notebooks in `python/notebooks/`

### Results 

* All raw execution data is stored in `runs/`.
* Averaged metrics are in `runs_mean/`.
* Plots and comparative charts can be generated using the provided notebooks.

## Key Findings

* SciPy proved to be more efficient than MATLAB in our tests, successfully handling two large matrices that MATLAB 
failed to compile.

* In the comparison between operating systems, Windows showed slightly better performance than Linux, 
although this could be due to virtualization overhead in the Linux environment.

More details and graphs are included in the **report** and **notebooks**.

## Authors

* [**Falbo Andrea**](#https://github.com/LilQuacky)
* [**Tenderini Ruben**](#https://github.com/Ruben-2828)

## License

This project is licensed under the MIT License – see the [LICENSE](./LICENSE) file for details.
