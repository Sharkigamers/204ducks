#/usr/bin/bash
test_exit_status () {
    command ./204ducks $2 &> /dev/null
    if [ $? == $1 ] ; then
        echo -e "\e[1m\e[92m"OK"\e[0m": $2 = $1
    else
        echo -e "\e[1m\e[91m"KO"\e[0m": $2 = $1
    fi
}
test_output () {
    EXPECT=mktemp
    OUTPUT=`command ./204ducks $2 2>&1 | sed "$1q;d"`
    echo -e $3 > $EXPECT
    echo $OUTPUT | diff - $EXPECT > /dev/null
    if [ $? == 0 ] ; then
        echo -e "\e[1m\e[92m"OK"\e[0m": $2
    else
        echo -e "\e[1m\e[91m"KO"\e[0m": $2 "<" $(<$EXPECT) "\n\t>" $OUTPUT
    fi
    rm -rf $EXPECT
}
echo "> testing status..."
test_exit_status 84 a
test_exit_status 84 10a
test_exit_status 84 -1
test_exit_status 84 2.6
test_exit_status 0 0
test_exit_status 0 1.5
test_exit_status 0 2.5
echo "> testing output..."
test_output 1 "1.6" "Average return time: 1m 21s"
test_output 1 "0.2" "Average return time: 0m 50s"
test_output 2 "1.6" "Standard deviation: 1.074"
test_output 2 "0.2" "Standard deviation: 0.676"
test_output 3 "1.6" "Time after which 50% of the ducks are back: 1m 04s"
test_output 3 "0.2" "Time after which 50% of the ducks are back: 0m 39s"
test_output 4 "1.6" "Time after which 99% of the ducks are back: 5m 04s"
test_output 4 "0.2" "Time after which 99% of the ducks are back: 3m 16s"
test_output 5 "1.6" "Percentage of ducks back after 1 minute: 46.9%"
test_output 5 "0.2" "Percentage of ducks back after 1 minute: 71.3%"
test_output 6 "1.6" "Percentage of ducks back after 2 minutes: 79.1%"
test_output 6 "0.2" "Percentage of ducks back after 2 minutes: 94.2%"