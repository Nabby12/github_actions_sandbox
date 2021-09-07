import os

SAMPLE_INPUT = os.environ['INPUT_SAMPLE_INPUT']

def main():
    sample_output = SAMPLE_INPUT + ' -> sample_output'

    # print("::add-mask::" + sample_output)
    print("::set-output name=sample_output::" + sample_output)

if __name__ == '__main__':
    main()
