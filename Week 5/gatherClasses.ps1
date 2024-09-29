function DaysTranslator($Days) {
    $DaysArray = @()

    if ($Days -ilike "*M*") {
        $DaysArray += "Monday"
    }
    if ($Days -ilike "*T*") {
        $DaysArray += "Tuesday"
    }
    if ($Days -ilike "*W*") {
        $DaysArray += "Wednesday"
    }
    if ($Days -ilike "*Th*") {
        $DaysArray += "Thursday"
    }
    if ($Days -ilike "*F*") {
        $DaysArray += "Friday"
    }
    if ($Days -ilike "*Sa*") {
        $DaysArray += "Saturday"
    }
    if ($Days -ilike "*Su*") {
        $DaysArray += "Sunday"
    }

    return $DaysArray
}

function gatherClasses(){

    $page = Invoke-WebRequest -TimeoutSec 2 -Uri "http://localhost/Courses-1.html"
    
    # Get all the tr elements of HTML Document
    $trs = $page.ParsedHtml.getElementsByTagName("tr")

    # Array to hold results
    $FullTable = @()
    for($i = 1; $i -le $trs.Length; $i++){

        # Get every td element of current tr element
        $tds = $trs[$i-1].getElementsByTagName("td")

        if ($tds.Length -ge 10) {
            # want to seperate start time and end time from one time field
            $Times = $tds[5].InnerText.Split(" - ")

            $Days = DaysTranslator $tds[4].InnerText

            $FullTable += [PSCustomObject]@{
                "Class Code" = $tds[0].InnerText
                "Title" = $tds[1].InnerText
                "Days" = $Days
                "Time Start" = $Times[0]
                "Time End" = $Times[1]
                "Instructor" = $tds[6].InnerText
                "Location" = $tds[9].InnerText
            }
        }
    }

    $FullTable
}