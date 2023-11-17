def get_unique(items):
    unique = set()
    not_unique = set()

    for item in items:
        if item in unique:
            unique.remove(item)
            not_unique.add(item)
        if item not in not_unique:
            unique.add(item)

    return unique
