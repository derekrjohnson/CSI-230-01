# invoke the page to be scraped
$scraped_page = Invoke-WebRequest -TimeoutSec 10 -Uri "http://localhost/ToBeScraped.html"

# Get a count of links
$scraped_page.Length

# Get links as HTML elements
$scraped_page.Links

# Display only url 
$scraped_page.Links | Format-Table outerText, href

# Get outer text of every element with the tag h2
$h2s=$scraped_page.ParsedHtml.body.getElementsByTagName("h2") | Format-Table outerText
$h2s

# Print innerText of every div element that has the class "div-1"
$divs1=$scraped_page.ParsedHtml.body.getElementsByTagName("div") | where { $_.getAttributeNode("class").Value -ilike "div-1" } | select innerText
$divs1