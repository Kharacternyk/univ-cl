from nltk.corpus import wordnet, wordnet_ic
from nltk.tag import pos_tag
from nltk.tokenize import word_tokenize

from unique import get_unique

brown_information_content = wordnet_ic.ic("ic-brown.dat")
brown_parts_of_speech = {
    "NOUN": wordnet.NOUN,
    "VERB": wordnet.VERB,
}


def get_synset(tagged_tokens, token, part_of_speech):
    best_synset = None
    best_score = 0

    for synset in wordnet.synsets(token, pos=brown_parts_of_speech[part_of_speech]):
        score = 0

        for sibling_token, sibling_part_of_speech in tagged_tokens:
            if sibling_part_of_speech != part_of_speech:
                continue

            similarity = 0

            for sibling_synset in wordnet.synsets(
                sibling_token, pos=brown_parts_of_speech[sibling_part_of_speech]
            ):
                similarity = max(similarity, lin_compare(synset, sibling_synset))

            score += similarity

        if score > best_score:
            best_score = score
            best_synset = synset

    return best_synset


def get_synsets(text, part_of_speech="NOUN"):
    tokens = word_tokenize(text)
    tagged_tokens = pos_tag(tokens, tagset="universal")
    unique_uncased_tokens = get_unique([token.lower() for token in tokens])
    synsets = {}

    for token, token_part_of_speech in tagged_tokens:
        if token_part_of_speech != part_of_speech:
            continue

        uncased_token = token.lower()

        if uncased_token not in unique_uncased_tokens:
            continue

        synset = get_synset(tagged_tokens, token, part_of_speech)

        if synset:
            synsets[uncased_token] = synset

    return synsets


def wu_palmer_compare(first_synset, second_synset):
    return first_synset.wup_similarity(second_synset)


def resnik_compare(first_synset, second_synset):
    return first_synset.res_similarity(
        second_synset, brown_information_content
    ) / first_synset.res_similarity(first_synset, brown_information_content)


def lin_compare(first_synset, second_synset):
    return first_synset.lin_similarity(second_synset, brown_information_content)
