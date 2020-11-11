# tomato-adblock
Tomato firmware adblock list

## Function
* A cron runs once per day to check if the adblock list still exists (Http status 200)
* If not, it puts the URL into a "bad" list
* This "bad" list should be checked manually to confirm
* If confirmed, the URL should be removed from the official list
