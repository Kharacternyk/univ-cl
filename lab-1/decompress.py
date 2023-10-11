import sys
from lib import *

if __name__ == '__main__':
    compressed_name = sys.argv[1]
    codec, raw_name, medium_name = parse_extension(compressed_name)
    with open(compressed_name, "rb") as file:
        compressed_blob = file.read()
    with open(medium_name, "rb") as file:
        medium_blob = file.read()
    text = codec.decompress(compressed_blob, medium_blob)
    check_write(raw_name, text)
