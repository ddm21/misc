import requests
from bs4 import BeautifulSoup

# URL of the webpage you want to scrape
url = "https://webscraper.io/test-sites"  # Replace with the actual URL you want to scrape

# Send an HTTP GET request to the URL
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    # Parse the HTML content of the webpage
    soup = BeautifulSoup(response.text, 'html.parser')

    # Find all the <a> (anchor) tags on the webpage
    links = soup.find_all('a')

    # Create a text file to save the data
    with open('links.txt', 'w', encoding='utf-8') as file:
        # Loop through each link and write its title and URL to the file
        for link in links:
            title = link.get_text(strip=True)
            url = link.get('href')
            if title and url:
                file.write(f"{title} | {url}\n")

    print("Links have been scraped and saved to 'links.txt'.")
else:
    print("Failed to retrieve the webpage. Check the URL or your internet connection.")


# requests==2.26.0
# beautifulsoup4==4.9.3
# pip install -r requirements.txt
