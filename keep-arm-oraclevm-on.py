### keep script running after closing terminal
# nohup keep-it-on.py

### To check the running background processes, you can use:
# ps -aux | grep keep-it-on.py

### to close the script
# kill PID

########################
#####  Code Below  #####
########################

import psutil
import time
import random
import multiprocessing

def burn_cpu():
    # This function will run indefinitely, consuming CPU
    while True:
        pass

def burn_memory():
    # This function will run indefinitely, consuming memory
    memory_block = bytearray(1024 * 1024 * 100)  # Allocate 100 MB memory block
    while True:
        pass

def monitor_system_resources():
    # Monitor CPU and memory utilization and adjust the number of CPU-burning and memory-burning processes
    min_cpu_utilization = 60
    max_cpu_utilization = 80
    min_memory_utilization = 40
    max_memory_utilization = 80
    num_cpu_processes = multiprocessing.cpu_count()
    num_memory_processes = 1
    utilization_tolerance = 5

    while True:
        desired_cpu_utilization = random.randint(min_cpu_utilization, max_cpu_utilization)
        desired_memory_utilization = random.randint(min_memory_utilization, max_memory_utilization)

        cpu_percent = psutil.cpu_percent(interval=1, percpu=False)
        memory_percent = psutil.virtual_memory().percent

        print(f"Current CPU utilization: {cpu_percent}%")
        print(f"Current memory utilization: {memory_percent}%")

        if cpu_percent < desired_cpu_utilization - utilization_tolerance:
            num_cpu_processes += 1
        elif cpu_percent > desired_cpu_utilization + utilization_tolerance:
            num_cpu_processes -= 1

        if memory_percent < desired_memory_utilization - utilization_tolerance:
            num_memory_processes += 1
        elif memory_percent > desired_memory_utilization + utilization_tolerance:
            num_memory_processes -= 1

        num_cpu_processes = max(1, min(num_cpu_processes, multiprocessing.cpu_count()))
        num_memory_processes = max(1, num_memory_processes)

        print(f"Desired CPU utilization: {desired_cpu_utilization}%")
        print(f"Desired memory utilization: {desired_memory_utilization}%")
        print(f"Number of CPU-burning processes: {num_cpu_processes}")
        print(f"Number of memory-burning processes: {num_memory_processes}")

        cpu_processes = [multiprocessing.Process(target=burn_cpu) for _ in range(num_cpu_processes)]
        memory_processes = [multiprocessing.Process(target=burn_memory) for _ in range(num_memory_processes)]

        # Start the CPU-burning processes
        for process in cpu_processes:
            process.start()

        # Start the memory-burning processes
        for process in memory_processes:
            process.start()

        # Wait for the specified time before adjusting again
        time.sleep(10)

        # Terminate the CPU-burning processes
        for process in cpu_processes:
            process.terminate()

        # Terminate the memory-burning processes
        for process in memory_processes:
            process.terminate()

        # Wait for the processes to terminate before re-adjusting
        for process in cpu_processes + memory_processes:
            process.join()

if __name__ == "__main__":
    try:
        monitor_system_resources()
    except KeyboardInterrupt:
        print("\nExiting the script.")
