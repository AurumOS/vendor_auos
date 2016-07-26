for device in $(cat vendor/au/au.devices)
do
add_lunch_combo au_$device-userdebug
done
