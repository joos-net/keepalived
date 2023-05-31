my_la=`cat /proc/loadavg |awk {'print $1'}`
la=$(echo $my_la*100 | bc)

new_weight=$(echo ${la%.*}/-2 | bc)
echo $new_weight > /usr/local/bin/check