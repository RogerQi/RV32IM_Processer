import sys

def main(src, dst):
    magic_counter = 2 # For some reason RISC-V tests use 2 as the starting indices...

    with open(dst, 'w') as dst_f:
        with open(src) as src_f:
            while True:
                cur_line = src_f.readline()
                if not cur_line: break
                if "MAGIC_COUNT" in cur_line:
                    cur_line = cur_line.replace("MAGIC_COUNT", str(magic_counter))
                    magic_counter = magic_counter + 1
                dst_f.write(cur_line)

if __name__ == "__main__":
    src_file_path = sys.argv[1]
    dst_file_path = sys.argv[2]
    main(src_file_path, dst_file_path)
