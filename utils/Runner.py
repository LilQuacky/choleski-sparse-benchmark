import os
import csv
import time
import psutil
import platform
import numpy as np
import scipy.io
import scipy.sparse as sp
from datetime import datetime
from sksparse.cholmod import cholesky
import gc

from utils.CSVLogger import CSVLogger
from utils.functions import measure_memory_mb, get_peak_memory_mb, get_nnz


class Runner:

    def __init__(self, matrices_path: str = '.', logs_path: str = ""):
        self.path = matrices_path
        self.logger = CSVLogger(platform.system().lower() + "_python", logs_path)

    def run(self):
        matrix_paths = [
            os.path.join(self.path, f)
            for f in os.listdir(self.path)
            if f.endswith(".mtx")
        ]

        matrix_files = sorted(matrix_paths, key=get_nnz)

        if not matrix_files:
            print("No matrices found in specified path")
            return

        for fname in matrix_files:
            self.process_matrix(fname)

        print(f"\nLog file: {self.logger.log_file}\n")

    def process_matrix(self, matrix_path: str):
        gc.collect()
        matrix_name = os.path.basename(matrix_path)

        try:
            print(f"\nLoading matrix: {matrix_name}")

            t0 = time.perf_counter()
            mem0 = measure_memory_mb()
            A = scipy.io.mmread(matrix_path)
            mem1 = measure_memory_mb()
            t1 = time.perf_counter()
            load_time = t1 - t0
            load_mem = mem1 - mem0

            n, m = A.shape
            nnz = A.nnz
            xe = np.ones(n)

            A_csr = A.tocsr()
            A_csc = A.tocsc()
            b = A_csr @ xe

            # Decomposizione (fattorizzazione)
            print(f"Decomposing matrix: {matrix_name}")
            gc.collect()
            mem2 = measure_memory_mb()
            t2 = time.perf_counter()
            factor = cholesky(A_csc)
            t3 = time.perf_counter()
            mem3 = measure_memory_mb()
            decomp_time = t3 - t2
            decomp_mem = mem3 - mem2
            decomp_peak = get_peak_memory_mb()

            # Risoluzione
            print(f"Solving matrix: {matrix_name}")
            gc.collect()
            mem4 = measure_memory_mb()
            t4 = time.perf_counter()
            x = factor(b)
            t5 = time.perf_counter()
            mem5 = measure_memory_mb()
            solve_time = t5 - t4
            solve_mem = mem5 - mem4
            solve_peak = get_peak_memory_mb()

            rel_err = np.linalg.norm(x - xe, ord=2) / np.linalg.norm(xe, ord=2)

            # Costruzione riga da loggare
            row = {
                "os": platform.system(),
                "timestamp": datetime.now().isoformat(timespec="seconds"),
                "matrixName": matrix_name,
                "rows": n,
                "cols": m,
                "nonZeros": nnz,
                "loadTime": f"{load_time:.6f}",
                "loadMem": f"{load_mem:.2f}",
                "decompTime": f"{decomp_time:.6f}",
                "decompMem": f"{decomp_mem:.2f}",
                "decompPeakMem": f"{decomp_peak:.2f}",
                "solveTime": f"{solve_time:.6f}",
                "solveMem": f"{solve_mem:.2f}",
                "solvePeakMem": f"{solve_peak:.2f}",
                "relativeError": f"{rel_err:.2e}"
            }

            print(f"Completed: {matrix_name} | total time: {load_time + decomp_time + solve_time:.4f}s")
            self.logger.write_row(row)

        except Exception as e:
            print(f"Error in {matrix_name}: {e}")

