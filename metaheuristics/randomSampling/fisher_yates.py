from numpy.random import default_rng  # creator for random number gen.


def shuffle(seq, random) -> None:
    """
    Shuffle a list or array randomly using the Fisher-Yates shuffle.

    :param seq: the list or array to shuffle
    :param random: the random number generator
    """
    ri = random.integers  # get function pointer to random.integers
    i = len(seq)  # i = length of sequence
    while i > 1:  # we iterate with i from len(seq) down to 2
        j = ri(i)  # ri will return an integer from 0..i-1
        i -= 1  # as we decrease i here, it actually goes from n-1..1
        seq[i], seq[j] = seq[j], seq[i]  # swap elements at i and j


if __name__ == "__main__":  # if we execute this script as program...
    seq = list(range(20))  # create list
    shuffle(seq, default_rng())  # shuffle using numpy random generator
    print(f"Shuffled list: {seq}")  # print result
