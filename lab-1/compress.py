import sys
from lib import *

if __name__ == '__main__':
    compressed_name = sys.argv[1]
    codec, raw_name, medium_name = parse_extension(compressed_name)
    with open(raw_name, encoding="utf-8") as file:
        text = file.read()
    medium_blob, compressed_blob = codec.compress(text)
    check_write(medium_name, medium_blob)
    check_write(compressed_name, compressed_blob)
    print(len(text), "->", len(medium_blob), "->", len(compressed_blob))
