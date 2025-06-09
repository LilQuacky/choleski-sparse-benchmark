import os
import psutil
import scipy


def measure_memory_mb() -> float:
    """
    Function to measure current memory usage.
    :return: Current memory usage in MB
    """
    return psutil.Process(os.getpid()).memory_info().rss / (1024 * 1024)


def get_peak_memory_mb() -> float:
    """
    Function to get peak memory usage
    :return: Peak memory usage in MB
    """
    return psutil.Process(os.getpid()).memory_info().peak_wset / (1024 * 1024) if hasattr(
        psutil.Process().memory_info(), "peak_wset") else 0


def get_nnz(path: str) -> int:
    """
    Function to get the number of non zeros given a .mtx matrix.
    :param path: Path to the .mtx matrix
    :return: Number of non zeros
    """
    try:
        A = scipy.io.mmread(path)
        return A.nnz
    except Exception as e:
        print(f"Error reading {path}: {e}")
        return int(float('inf'))
