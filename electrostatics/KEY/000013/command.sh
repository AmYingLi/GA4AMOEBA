    
for i in `seq -f %04g 1 10 5785`; do
    cp /lcrc/project/HP_Li/multipole/2methanol/GA-fitting/xyz/$i.xyz 2me.xyz
    cp /lcrc/project/HP_Li/multipole/2methanol/GA-fitting/pot/$i.pot 2me.pot
    ./potential 5 2me.xyz 2me.key 2me.pot N >log-$i
    grep Root    log-$i| awk '{printf "%s  ", $7;}'>  ESP-$i
    awk '{print $1}' ESP-$i >> ESP.iie
done

