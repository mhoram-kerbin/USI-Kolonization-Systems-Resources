set terminal png  background "#ffffff" nocrop enhanced size 900,700 font "arial,12" 
set output 'supplies.png'

HoursInYear = 2556.50
SecInYear = HoursInYear * 60 * 60

UnitsPerSecond = 0.00005
MassPerUnit = 0.0012

Nom5Mass = 1.5
Nom25Mass = 4.5
Nom5Factor = 2

FertilizerUnitsPerSecond = 0.00004

supplies(k,d) = MassPerUnit * k * d * SecInYear * UnitsPerSecond

NomOMatic5kGreenhouse(k,d,nm) = MassPerUnit * k * d * SecInYear * UnitsPerSecond / Nom5Factor + k * nm

NomOMatic25kGreenhouse(k,d) = MassPerUnit * k * d * SecInYear * UnitsPerSecond / Nom5Factor + ceil(k/4) * Nom25Mass

NomOMatic25kFertilizer(k,d) = ceil(k/4) * Nom25Mass + 0.12 + MassPerUnit * k * d * SecInYear * FertilizerUnitsPerSecond / 4

NomOMaticMix(k,d,nm) = floor(k/4) * Nom25Mass + floor(k/4) * d * SecInYear * FertilizerUnitsPerSecond * MassPerUnit + (int(k) % 4) * (nm + MassPerUnit * d * SecInYear * UnitsPerSecond / Nom5Factor)

NomOMatic25kMix(k,d) = floor(k/4) * Nom25Mass + floor(k/4) * d * SecInYear * FertilizerUnitsPerSecond * MassPerUnit + (int(k) % 4) * MassPerUnit * d * SecInYear * UnitsPerSecond / Nom5Factor

set grid nopolar
set grid xtics nomxtics ytics nomytics noztics nomztics nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid layerdefault   lt black linewidth 0.200 dashtype solid,  lt black linewidth 0.200 dashtype solid
set isosamples 30,31
set samples 30,31
set xrange [1:30]
set yrange [0:30]
set zrange [0:500]
set xlabel "Kerbals"
set ylabel "Duration (y)"
set zlabel "Mass (ton)"


set title "Strategy 1: Bring supplies only (Default config)"
splot supplies(x,y) lt rgb "#FF0000"

set output 'nom5k.png'
set title "Strategy 2: Bring Nom5k and supplies (Default config)"
splot NomOMatic5kGreenhouse(x,y,1.5) lt rgb "#008000"

set output 'nom25kG.png'
set title "Strategy 3: Bring Nom25k and supplies (Default config)"
splot NomOMatic25kGreenhouse(x,y) lt rgb "#0000FF"

set output 'nom25kF.png'
set title "Strategy 4: Bring Nom25k and fertilizer (Default config)"
splot NomOMatic25kFertilizer(x,y) lt rgb "#800080"

set output 'nomMix.png'
set title "Strategy 5: Bring a Mixture of Nom25k and Nom5k (Default config)"
splot NomOMaticMix(x,y,1.5) lt rgb "#d0d000"

set output 'nom25kMix.png'
set title "Strategy 6: Bring Nom25k and a mixture of Fertilizer and Supplies (Default config)"
splot NomOMatic25kMix(x,y) lt rgb "#80FF80"

set output 'combi.png'
set title "Combination Plot (Default config)"
set multiplot
set key at 30,30,790
splot supplies(x,y) lt rgb "#FF0000"
set key at 30,30,740
splot NomOMatic5kGreenhouse(x,y,1.5) lt rgb "#008000"
set key at 30,30,690
splot NomOMatic25kGreenhouse(x,y) lt rgb "#0000FF"
set key at 30,30,640
splot NomOMatic25kFertilizer(x,y) lt rgb "#800080"
set key at 30,30,590
splot NomOMaticMix(x,y,1.5) lt rgb "#d0d000"
set key at 30,30,540
splot NomOMatic25kMix(x,y) lt rgb "#80FF80"

unset multiplot

SuppliesBest(k,d,nm) = (supplies(k,d) <= NomOMatic5kGreenhouse(k,d,nm) && supplies(k,d) <= NomOMatic25kFertilizer(k,d) && supplies(k,d) <= NomOMatic25kGreenhouse(k,d) && (supplies(k,d) <= NomOMaticMix(k,d,nm) || k < 4 || int(k) % 4 == 0) && (supplies(k,d) <= NomOMatic25kMix(k,d) || k < 4 || int(k) % 4 == 0)) ? supplies(k,d) : -1000

Nom5kBest(k,d,nm) = (NomOMatic5kGreenhouse(k,d,nm) < supplies(k,d) && NomOMatic5kGreenhouse(k,d,nm) <= NomOMatic25kFertilizer(k,d) && NomOMatic5kGreenhouse(k,d,nm) <= NomOMatic25kGreenhouse(k,d) && (NomOMatic5kGreenhouse(k,d,nm) <= NomOMaticMix(k,d,nm) || k < 4 || int(k) % 4 == 0) && (NomOMatic5kGreenhouse(k,d,nm) <= NomOMatic25kMix(k,d) || k < 4 || int(k) % 4 == 0)) ? NomOMatic5kGreenhouse(k,d,nm) : -1000

Nom25kGreenhouseBest(k,d,nm) = (NomOMatic25kGreenhouse(k,d) < supplies(k,d) && NomOMatic25kGreenhouse(k,d) <= NomOMatic25kFertilizer(k,d) && NomOMatic25kGreenhouse(k,d) < NomOMatic5kGreenhouse(k,d,nm) && (NomOMatic25kGreenhouse(k,d) <= NomOMaticMix(k,d,nm) || k < 4 || int(k) % 4 == 0) && (NomOMatic25kGreenhouse(k,d) <= NomOMatic25kMix(k,d) || k < 4 || int(k) % 4 == 0)) ? NomOMatic25kGreenhouse(k,d) : -1000

Nom25kFertilizerBest(k,d,nm) = (NomOMatic25kFertilizer(k,d) < supplies(k,d) && NomOMatic25kFertilizer(k,d) < NomOMatic25kGreenhouse(k,d) && NomOMatic25kFertilizer(k,d) < NomOMatic5kGreenhouse(k,d,nm) && (NomOMatic25kFertilizer(k,d) <= NomOMaticMix(k,d,nm) || k < 4 || int(k) % 4 == 0) && (NomOMatic25kFertilizer(k,d) <= NomOMatic25kMix(k,d) || k < 4 || int(k) % 4 == 0)) ? NomOMatic25kFertilizer(k,d) : -1000

NomMixBest(k,d,nm) = (int(k) % 4 != 0 && k > 3 && NomOMaticMix(k,d,nm) < supplies(k,d) && NomOMaticMix(k,d,nm) < NomOMatic25kGreenhouse(k,d) && NomOMaticMix(k,d,nm) < NomOMatic5kGreenhouse(k,d,nm) && NomOMaticMix(k,d,nm) < NomOMatic25kFertilizer(k,d) && (NomOMaticMix(k,d,nm) <= NomOMatic25kMix(k,d) || k < 4 || int(k) % 4 == 0)) ? NomOMaticMix(k,d,nm) : -1000

Nom25kMixBest(k,d,nm) = (k > 3 && int(k) % 4 != 0 && NomOMatic25kMix(k,d) < supplies(k,d) && NomOMatic25kMix(k,d) < NomOMatic25kGreenhouse(k,d) && NomOMatic25kMix(k,d) < NomOMatic5kGreenhouse(k,d,nm) && NomOMatic25kMix(k,d) < NomOMatic25kFertilizer(k,d) && (NomOMatic25kMix(k,d) < NomOMaticMix(k,d,nm) || k < 4 || int(k) % 4 == 0)) ? NomOMatic25kMix(k,d) : -1000

set output 'min.png'
set multiplot
set title "Best Choice (Default config)"
set key at 30,30,540
splot Nom25kMixBest(x,y,1.5) lt rgb "#80FF80"
set key at 30,30,590
splot NomMixBest(x,y,1.5) lt rgb "#d0d000"
set key at 30,30,640
splot Nom25kFertilizerBest(x,y,1.5) lt rgb "#800080"
set key at 30,30,690
splot Nom25kGreenhouseBest(x,y,1.5) lt rgb "#0000FF"
set key at 30,30,740
splot Nom5kBest(x,y,1.5) lt rgb "#008000"
set key at 30,30,790
splot SuppliesBest(x,y,1.5) lt rgb "#FF0000"
unset multiplot


set output 'minBetter.png'
set multiplot
set title "Best Choice (Nom-O-Matic5k has a mass of 0.55 ton)"
set key at 30,30,540
newm = 0.55
splot Nom25kMixBest(x,y,newm) lt rgb "#80FF80"
set key at 30,30,590
splot NomMixBest(x,y,newm) lt rgb "#d0d000"
set key at 30,30,640
splot Nom25kFertilizerBest(x,y,newm) lt rgb "#800080"
set key at 30,30,690
splot Nom25kGreenhouseBest(x,y,newm) lt rgb "#0000FF"
set key at 30,30,740
splot Nom5kBest(x,y,newm) lt rgb "#008000"
set key at 30,30,790
splot SuppliesBest(x,y,newm) lt rgb "#FF0000"
unset multiplot
