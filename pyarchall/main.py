from fire import Fire

from .downloader import download


def main():
    Fire(download)


if __name__ == "__main__":
    main()
