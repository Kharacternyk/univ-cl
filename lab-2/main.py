from csv import writer
from random import sample

from tqdm import tqdm

from bert import bert_compare, get_vectors
from pandas import read_csv
from wordnet import get_synsets, lin_compare, resnik_compare, wu_palmer_compare


def format(value):
    return f"{value:.2f}"


frame = read_csv("bbc_news.csv")
descriptions = frame.sample(100)["description"]

with open("result.csv", "a", newline="") as result_file:
    result_writer = writer(result_file)

    for description in tqdm(descriptions):
        vectors = get_vectors(description)
        synsets = get_synsets(description)
        intersection = vectors.keys() & synsets.keys()

        if len(intersection) < 2:
            continue

        first, second = sample(list(intersection), 2)

        result_writer.writerow(
            [
                description,
                first,
                second,
                format(wu_palmer_compare(synsets[first], synsets[second])),
                format(resnik_compare(synsets[first], synsets[second])),
                format(lin_compare(synsets[first], synsets[second])),
                format(bert_compare(vectors[first], vectors[second])),
                synsets[first].definition(),
                synsets[second].definition(),
            ]
        )
