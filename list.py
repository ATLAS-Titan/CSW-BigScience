for each job in jobs:

    candidate_queues = []
    for queue in queues:
        if match_constraints(job, queue):
            candidate_queues.append(queue)

    best_queue = candidate_queues[0]
    max_weight = 0
    for queue in candidate_queues:
        queue_weight = calculate_weight(queue)
        if queue_weight > max_weight:
            best_queue = queue
            max_weight = queue_weight

    assign(job, best_queue)
