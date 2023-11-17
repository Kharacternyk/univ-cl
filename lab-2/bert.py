from torch import no_grad, squeeze, stack, sum, tensor
from torch.nn import CosineSimilarity
from transformers import BertModel, BertTokenizer

from unique import get_unique

model_name = "bert-base-uncased"
model = BertModel.from_pretrained(model_name, output_hidden_states=True)
tokenizer = BertTokenizer.from_pretrained(model_name)
similarity = CosineSimilarity(dim=0)


@no_grad()
def get_vectors(text):
    delimited_text = f"[CLS] {text} [SEP]"
    tokens = tokenizer.tokenize(delimited_text)
    token_identities = tokenizer.convert_tokens_to_ids(tokens)
    token_tensor = tensor([token_identities])
    segments = [1 for _ in tokens]
    segment_tensor = tensor([segments])
    output = model(token_tensor, segment_tensor)
    hidden_states = output[2]
    embeddings = squeeze(stack(hidden_states, dim=0), dim=1).permute(1, 0, 2)
    unique_tokens = get_unique(tokens)
    vectors = {}

    for index, token in enumerate(tokens):
        if token in unique_tokens:
            vectors[token] = sum(embeddings[index][-4:], dim=0)

    return vectors


def bert_compare(first_vector, second_vector):
    return similarity(first_vector, second_vector).item()
