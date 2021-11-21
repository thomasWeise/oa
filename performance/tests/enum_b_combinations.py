total: int = 0  # the total number of enumerated combinations
leq_4: int = 0  # the number of combinations with mean <= 4

for i1 in range(1, 11):  # enumerate from 0 to 10
    for i2 in range(i1 + 1, 11):  # from i1+1 to 10
        for i3 in range(i2 + 1, 11):  # from i2+1 to 10
            for i4 in range(i3 + 1, 11):  # from i3+1 to 10
                mean = (i1 + i2 + i3 + i4) / 4.0  # compute mean
                if mean <= 4:
                    leq_4 += 1  # step counter for mean <= 4
                    print(f"{i1}, {i2}, {i3}, {i4}, mean={mean}")
                total += 1  # step total counter

print(f"total combinations: {total}")
print(f"combinations with mean <= 4: {leq_4}")

