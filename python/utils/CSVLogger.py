import csv
import os
from datetime import datetime
from typing import Collection


class CSVLogger:

    def __init__(self, filename: str = None, path: str = ""):
        self._log_file = self._create_log_file_path(filename, path)

    @property
    def log_file(self):
        return self._log_file

    def _create_log_file_path(self, filename: str, path: str):
        if filename is None:
            filename = 'log_chol'

        filename += "_" + datetime.now().strftime("%Y_%m_%d_%H%M%S") + ".csv"
        log_file = os.path.join(path, filename)

        os.makedirs(path, exist_ok=True)
        return log_file

    def write_row(self, data: dict):
        with open(self._log_file, 'a', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=data.keys())
            if os.stat(self._log_file).st_size == 0:
                writer.writeheader()
            writer.writerow(data)
