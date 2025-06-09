import os
import psutil
import scipy


def measure_memory_mb():
    return psutil.Process(os.getpid()).memory_info().rss / (1024 * 1024)


def get_peak_memory_mb():
    return psutil.Process(os.getpid()).memory_info().peak_wset / (1024 * 1024) if hasattr(
        psutil.Process().memory_info(), "peak_wset") else 0


def get_nnz(path):
    try:
        A = scipy.io.mmread(path)
        return A.nnz
    except Exception as e:
        print(f"Error reading {path}: {e}")
        return float('inf')
