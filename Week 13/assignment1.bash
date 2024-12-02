#! /bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){

echo -n "Please Input an Instructor Full Name: "
read instName

echo ""
echo "Courses of $instName :"
cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | \
sed 's/;/ | /g'
echo ""

}

function courseCountofInsts(){

echo ""
echo "Course-Instructor Distribution"
cat "$courseFile" | cut -d';' -f7 | \
grep -v "/" | grep -v "\.\.\." | \
sort -n | uniq -c | sort -n -r 
echo ""

}

# TODO - 1
# Make a function that displays all the courses in given location
# function dislaplays course code, course name, course days, time, instructor
# Add function to the menu
# Example input: JOYC 310
# Example output: See the screenshots in canvas
function coursesByLocation(){
	echo -n "Please enter a class location: "
	read location

	echo ""
	echo "Courses in $location: "
	cat "$courseFile" | grep "$location" | cut -d';' -f1,2 | \
	sed 's/;/ | /g'
	echo ""
}


# TODO - 2
# Make a function that displays all the courses that has availability
# (seat number will be more than 0) for the given course code
# Add function to the menu
# Example input: SEC
# Example output: See the screenshots in canvas
function coursesByAvailability() {
	# Store course data in a variable
	courseData=$(cut -d';' -f1,4 "$courseFile")

	# iterate over each line in the courseData
	echo "$courseData" | while IFS=';' read -r course_name seats_available; do
		if [ "$seats_available" -gt 0 ]; then
			echo "Course: $course_name, Seats available; $seats_available"
		fi
done
}

while :
do
	echo ""
	echo "Please select and option:"
	echo "[1] Display courses of an instructor"
	echo "[2] Display course count of instructors"
	echo "[3] Display courses by location"
	echo "[4] Display courses by availability"
	echo "[5] Exit"

	read userInput
	echo ""

	if [[ "$userInput" == "5" ]]; then
		echo "Goodbye"
		break

	elif [[ "$userInput" == "1" ]]; then
		displayCoursesofInst

	elif [[ "$userInput" == "2" ]]; then
		courseCountofInsts

	elif [[ "$userInput" == "3" ]]; then
		coursesByLocation

	elif [[ "$userInput" == "4" ]]; then
		coursesByAvailability

	else
		echo "Please choose an option 1-5: "
	# TODO - 3 Display a message, if an invalid input is given
	fi
done
