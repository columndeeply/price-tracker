# About the project
This is a collection of POSIX shell scripts meant to track price changes on different websites. It's written in a modular style meaning you can write your own price parses for any site you want. As long as your parser returns the two required details (name and price) it should work just fine.

# Requirements
There are three requirements, if any of these packages are not installed none of the scripts will run. Make sure to install them:
- [sqlite3](https://github.com/sqlite/sqlite): all the price history and tracked products are stored in a sqlite database.
- [pup](https://github.com/ericchiang/pup): used to parse the HTML and extract the name and price.
- bc: does some math. It usually comes installed by default in most distros.

# Installation
First you'll need to clone this repository. Once you have the project somewhere on your system you should add some URLs to track by running the `toggle.sh` script.

    git clone https://github.com/columndeeply/price-tracker.git
    cd price-tracker
    sh toggle.sh "https://product-url.com/product/1"

Once that's done you can add a cronjob to check the prices at certain times. For example, I check the prices every two hours with this cronjob:

    0 */2 * * * sh $HOME/price-tracker/check.sh

# Configuration
The only thing you need to change in the `config.sh` file is the variable `root`. This variable should point to the path where you cloned the repository.

Optionally, you can change these variables:
- `logs`: path to the folder where the URLs will be downloaded when running the `check.sh` script.
- `debug`: change it to `1` and the script will stop removing the HTML files downloaded once a product has been processed.
- `max_retries`: how many times the script will try to download a URL before giving up.
- `wait_time`: how many seconds to wait between each URL download. You can set it to 0 but some sites tend to ban your IP if you're downloading pages too fast.

# Usage
## Adding/removing products
To add or remove a product just run the `toggle.sh` script with the URL as the first parameter. If it exists in the DB it will remove it. Otherwise, it will add it.

## Checking all prices
Run the `check.sh` script

## Setting up the notifications
To receive notifications when a price drops you'll need to change the `notifier.sh` script. This script will always be called when a price changes and it will receive as the first parameter a text that includes the product name, the old price, the new price and its URL. I'm using the `go-sendxmpp` package to receive notifications on my XMPP account but you can change it to send an email, send a notification through Telegram, etc.

# Writing new parsers
You can write a parser for any site you want. The only requirements are:
- The script is named with the full domain of the site without any dots or special characters:
  - A parser for `example.it` should be named `exampleit.sh`. One for `nl.example.org` should be named `nlexampleorg.sh`. 
  - The example parser I've included is for this domain `demo.ecommercehtml.com`, therefore it's named `demoecommercehtmlcom.sh`.
- It receives a URL in the first parameter.
- It downloads said URL using the `file_downloader.sh` script.
- It returns two lines starting with:
  - `title/`: should be the name of the product. For example: `title/Oculus VR`
  - `price/`: should be the current price of the product. For example: `price/149 €`. Preferably it should return only the amount, without extra characters like € or $, but it doesn't really matter.

Optionally your parser can also return extra lines starting with `extras/` with some more information you might want to have in the notification (how many units are in stock or something similar).
**The `title/` and `price/` fields are mandatory. If the price is empty you should still return a line for it. Same with the name.**

## URL cleaning
Since the `toggle.sh` script uses the URL of a product to check if it already in the database you might want to clean up some URLs to avoid duplicates. To do this you can modify the `url_cleaner.sh` script to remove unneeded parameters from the URLs. If you're using a plugin like [ClearURLs](https://addons.mozilla.org/firefox/addon/clearurls/) this isn't really needed.

# Licence
Distributed under the GNU General Public License v3.0 licence. See the [LICENCE](https://github.com/columndeeply/price-tracker/blob/main/LICENSE) file for more information.

# Disclaimer
Please be mindful of how many products you're tracking, try to avoid hammering a site too much. Keep it to a few products per site. I'm not responsible if you get your IP banned or your account blocked from any sites while using this script.
