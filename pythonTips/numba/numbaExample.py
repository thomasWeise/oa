import timeit, numpy as np, numba

# a typical situation: compute makespan of Gantt chart in JSSP exmaple
def makespan_plain(x) -> int:
    return int(x[:, -1, 2].max())

# the exactly same method, but with numba in nopython/nogil mode
@numba.njit(nogil=True, cache=True)
def makespan_numba(x) -> int:
    return int(x[:, -1, 2].max())

x = np.ndarray((20, 20, 3), int); x.fill(1) # allocate variables
makespan_plain(x); makespan_numba(x)        # one warm-up call/function

# now time the plain and the numba variant
t1 = timeit.timeit(stmt="makespan_plain(x)", number=1000000,
                   globals={"x": x, "makespan_plain": makespan_plain})
t2 = timeit.timeit(stmt="makespan_numba(x)", number=1000000,
                   globals={"x": x, "makespan_numba": makespan_numba})

print(f"plain: {t1}\nnumba: {t2}")
