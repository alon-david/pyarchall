import asyncio
import os
from http import HTTPStatus

import aiofiles
import aiohttp
import requests
import tqdm
from bs4 import BeautifulSoup


async def _download(link: str, filename: str) -> None:
    async with aiohttp.ClientSession() as s:
        async with s.get(link) as resp:
            if resp.status == HTTPStatus.OK:
                data = await resp.read()
                async with aiofiles.open(filename, mode="wb") as f:
                    await f.write(data)

    print(filename)  # TODO: change to async TQDM


def download(package: str, pypi_server: str = "https://pypi.org"):
    os.makedirs(name=package, exist_ok=True)

    resp = requests.get(url=f"{pypi_server}/simple/{package}")
    html = resp.text
    soup = BeautifulSoup(html, "html.parser")
    links = [a.get("href") for a in soup.find_all("a")]

    dir_name = f"pyarchive-{package}"
    os.makedirs(name=dir_name, exist_ok=True)
    os.chdir(path=dir_name)

    loop = asyncio.new_event_loop()
    tasks = []
    for link in tqdm.tqdm(links, desc="launching downloads"):
        file_name = link.split("#")[0].split("/")[-1]
        tasks.append(loop.create_task(_download(link=link, filename=file_name)))

    group = asyncio.gather(*tasks, loop=loop)
    loop.run_until_complete(group)
    loop.close()
