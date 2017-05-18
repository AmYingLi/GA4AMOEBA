    
for i in `seq -f %04g 1 1 10`; do
    cp ../../xyz/$i.xyz 2me.xyz
    cp ../../pot/$i.pot 2me.pot
    ./potential 5 2me.xyz 2me.key 2me.pot N >log-$i
    grep Root    log-$i| awk '{printf "%s  ", $7;}'>  ESP-$i
    awk '{print $1}' ESP-$i >> ESP.iie
done

