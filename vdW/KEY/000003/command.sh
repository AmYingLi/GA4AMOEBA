    
for i in `seq -f %03g 0 1 9`; do
    cp ../../xyz/methanol_a-$i.xyz methanol.xyz
    ./analyze methanol.xyz E >log-$i
    cp ../../xyz/methanol_b-$i.xyz methanol.xyz
    ./analyze methanol.xyz E >>log-$i
    cp ../../xyz/methanol_ab-$i.xyz methanol.xyz
    ./analyze methanol.xyz E >>log-$i
    grep Total    log-$i| awk '{printf "%s  ", $5;}'>  TE-$i
    awk '{print    ($3-$2-$1); }'  TE-$i >>  molecules.iie
done

