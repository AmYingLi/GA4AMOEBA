    
for i in `seq -f %03g 0 1 750`; do
    cp /gpfs/mira-fs1/projects/catalyst/yingli/Tinker/pff/fitting/interface/mix_MP2_6-31G/xyz/methanol_a-$i.xyz methanol.xyz
    ./analyze methanol.xyz E >log-$i
    cp /gpfs/mira-fs1/projects/catalyst/yingli/Tinker/pff/fitting/interface/mix_MP2_6-31G/xyz/methanol_b-$i.xyz methanol.xyz
    ./analyze methanol.xyz E >>log-$i
    cp /gpfs/mira-fs1/projects/catalyst/yingli/Tinker/pff/fitting/interface/mix_MP2_6-31G/xyz/methanol_ab-$i.xyz methanol.xyz
    ./analyze methanol.xyz E >>log-$i
    grep Total    log-$i| awk '{printf "%s  ", $5;}'>  TE-$i
    awk '{print    ($3-$2-$1); }'  TE-$i >>  molecules.iie
done

