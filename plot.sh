#!/bin/bash

awk '{vote=$4; seats=$5/$6*100; delta=seats-vote; print $1,$2,vote, seats, delta}' ge-data > ge-data.gp
awk '{vote=$4; seats=$5/$6*100; delta=seats-vote; print $1,$2,vote, seats, delta}' ge-data-scotland > ge-data-scotland.gp

xaxis_end=20180508
GP_PREAMBLE='
	set xdata time
	set timefmt "%Y%m%d"

	set grid
	set border 3
	set tics nomirror
	set xtics rotate
	set ytics -100,10
	set xtics("19700618", "19740228", "19741010", "19790503", "19830609", "19870611", "19920409", "19970501", "20010607", "20050505", "20100506", "20150507", "20200507")

	set xrange ["19700618":"'$xaxis_end'"]

	set linestyle 1 lt 1 lw 2 lc rgb "#0645AD" pt 7 ps 0.75;
	set linestyle 2 lt 1 lw 2 lc rgb "#DC241F" pt 7 ps 1;
	set linestyle 3 lt 1 lw 2 lc rgb "#FE8301" pt 7 ps 1;
	set linestyle 4 lt 1 lw 2 lc rgb "#EBC31C" pt 7 ps 1;
	set linestyle 9 lt 1 lw 2 lc rgb "#000000" pt 7 ps 1;

	set style fill noborder

	set key horiz at screen 0.5, 0.95 center
'

gnuplot <<EOF
	set term pngcairo size 800,800 dashed
	$GP_PREAMBLE

	set output "ge2015-uk.png"
	set multiplot

	set size 0.99,0.48
	set origin 0.01,0.01
	set yrange [0:100]
	set ylabel "Seat share (%)"

	set arrow from "20150507",0 to "20150507",100 nohead lc rgb "red"
	set arrow from "19700618",50 to "$xaxis_end",50 nohead lc rgb 'black'

	set format x "%b %Y"
	plot '<grep Con ge-data.gp' using 1:4 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data.gp' using 1:4 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data.gp' using 1:4 ti "Libs" w linespoints ls 3,\
	     '<grep SNP ge-data.gp' using 1:4 ti "SNP" w linespoints ls 4

	set size 0.99,0.48
	set origin 0.01,0.51
	set ylabel "Vote share (%)"

	# remove xtic labels
	set format x ""
	plot '<grep Con ge-data.gp' using 1:3 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data.gp' using 1:3 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data.gp' using 1:3 ti "Libs" w linespoints ls 3,\
	     '<grep SNP ge-data.gp' using 1:3 ti "SNP" w linespoints ls 4
EOF

gnuplot <<EOF
	set term pngcairo size 800,800 dashed
	$GP_PREAMBLE

	set output "ge2015-sc.png"
	set multiplot

	set size 0.99,0.48
	set origin 0.01,0.01
	set yrange [0:100]
	set ylabel "Seat share (%)"

	set arrow from "20150507",0 to "20150507",100 nohead lc rgb "red"
	set arrow from "19700618",50 to "$xaxis_end",50 nohead lc rgb 'black'

	# remove xtic labels
	set format x "%b %Y"
	plot '<grep Con ge-data-scotland.gp' using 1:4 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:4 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:4 ti "Libs" w linespoints ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:4 ti "SNP" w linespoints ls 4

	set size 0.99,0.48
	set origin 0.01,0.51
	set ylabel "Vote share (%)"
	set format x ""
	plot '<grep Con ge-data-scotland.gp' using 1:3 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:3 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:3 ti "Libs" w linespoints ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:3 ti "SNP" w linespoints ls 4
EOF

gnuplot <<EOF
	set term pngcairo size 800,300 dashed
	$GP_PREAMBLE

	set arrow from "20150507",-50 to "20150507",50 nohead lc rgb "red"
	set arrow from "19700618",0 to "$xaxis_end",0 nohead lc rgb "black"
	set yrange [-50:50]
	set format x "%b %Y"
	set ylabel "% difference, votes to seat share"

	set output "ge2015-sc-diff.png"
	plot '<grep Con ge-data-scotland.gp' using 1:5 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:5 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:5 ti "Libs" w linespoints ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:5 ti "SNP" w linespoints ls 4

	set output "ge2015-uk-diff.png"
	plot '<grep Con ge-data.gp' using 1:5 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data.gp' using 1:5 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data.gp' using 1:5 ti "Libs" w linespoints ls 3,\
	     '<grep SNP ge-data.gp' using 1:5 ti "SNP" w linespoints ls 4
EOF

