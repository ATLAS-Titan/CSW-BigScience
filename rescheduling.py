active_jobs = []
current_time = date("January 1, 2016")
job_traces = original_traces.sort_by_start_time()
max_nodes = 18688

for job in job_traces:
    active_nodes = count_active_nodes()
    requested_nodes = job["requested_nodes"]
    while active_nodes + requested_nodes > max_nodes:
      # Advance the simulation time to the time that
      # the next job ends, when resources will be freed.
        current_time = get_next_completion_time()
        evict_and_log_completed_jobs()
        active_nodes = count_active_nodes()
    active_jobs.append(job)

while len(active_jobs) > 0:
    current_time = get_next_completion_time()
    evict_and_log_completed_jobs()
