import multiprocessing
import psutil
import logging
from typing import Dict

logger = logging.getLogger("ResourceGovernor")

class ResourceGovernor:
    @staticmethod
    def get_optimized_worker_count(reserved_percentage: float = 0.20) -> int:
        """
        Detects CPU cores and reserves capacity for OS and critical tasks.
        On a 56-core system, this returns 44-45 workers.
        """
        total_cores = multiprocessing.cpu_count()
        reserved = max(1, int(total_cores * reserved_percentage))
        available = total_cores - reserved
        
        logger.info(f"System Hardware: {total_cores} Cores detected. Reserved: {reserved}. Workers allocated: {available}")
        return available

    @staticmethod
    def get_memory_safe_chunk_size(bars_count: int) -> int:
        """
        Adjusts processing chunk sizes based on available RAM.
        Prevents OOM (Out of Memory) on 10-year datasets.
        """
        vm = psutil.virtual_memory()
        available_gb = vm.available / (1024**3)
        
        if available_gb > 16:
            return 100000 # High Performance
        elif available_gb > 8:
            return 50000
        else:
            return 10000 # Conservative
