#!/bin/bash

awk '{vote=$4; seats=$5/$6*100; delta=seats-vote; print $1,$2,vote, seats, delta}' ge-data > ge-data.gp
awk '{vote=$4; seats=$5/$6*100; delta=seats-vote; print $1,$2,vote, seats, delta}' ge-data-scotland > ge-data-scotland.gp


gnuplot <<EOF
	set term pngcairo size 800,800 dashed

	set xdata time
	set timefmt "%Y%m%d"

	set grid
	set border 3
	set tics nomirror
	set xtics rotate
	set ytics 0,10
	set xtics("19700618", "19740228", "19741010", "19790503", "19830609", "19870611", "19920409", "19970501", "20010607", "20050505", "20100506", "20150507", "20200507")

	set yrange [0:100]
	set xrange ["19700618":"20180508"]

	set linestyle 1 lt 1 lw 2 lc rgb "#0645AD" pt 7 ps 0.75;
	set linestyle 2 lt 1 lw 2 lc rgb "#DC241F" pt 7 ps 1;
	set linestyle 3 lt 1 lw 2 lc rgb "#FE8301" pt 7 ps 1;
	set linestyle 4 lt 1 lw 2 lc rgb "#EBC31C" pt 7 ps 1;
	set linestyle 9 lt 1 lw 2 lc rgb "#000000" pt 7 ps 1;

	set style fill noborder

	set key horiz at screen 0.5, 0.95 center
	set arrow from "20150507",0 to "20150507",100 nohead lc rgb 'red'

	set output "ge2015-boxplot.png"
	set multiplot

	set size 0.99,0.48
	set origin 0.01,0.01
	set ylabel "Percentage Seats"

	set format x "%b %Y"
	plot '<grep Con ge-data.gp' using 1:4 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data.gp' using 1:4 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data.gp' using 1:4 ti "Libs" w linespoints ls 3

	set size 0.99,0.48
	set origin 0.01,0.51
	set ylabel "Percentage Vote"

	# remove xtic labels
	set format x ""
	plot '<grep Con ge-data.gp' using 1:3 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data.gp' using 1:3 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data.gp' using 1:3 ti "Libs" w linespoints ls 3


	unset multiplot

	set output "ge2015-scotland-stepped.png"
	set multiplot

	set size 0.99,0.48
	set origin 0.01,0.01
	set ylabel "Percentage Seats"

	# remove xtic labels
	set format x "%b %Y"
	plot '<grep Con ge-data-scotland.gp' using 1:4 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:4 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:4 ti "Libs" w linespoints ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:4 ti "SNP" w linespoints ls 4

	set size 0.99,0.48
	set origin 0.01,0.51
	set ylabel "Percentage Vote"
	set format x ""
	plot '<grep Con ge-data-scotland.gp' using 1:3 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:3 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:3 ti "Libs" w linespoints ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:3 ti "SNP" w linespoints ls 4

	unset multiplot

	set term pngcairo size 800,400 dashed
	set yrange [-50:50]
	set arrow from "20150507",-50 to "20150507",30 nohead lc rgb 'red'
	set ytics -50,10
	set xzeroaxis lw 3
	set xtic scale 0
	set origin 0.01,0.01
	set size 0.99,0.99
	set border 2
	set format x "%b %Y"

	set output "ge2015-scotland-diff.png"
	plot '<grep Con ge-data-scotland.gp' using 1:5 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:5 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:5 ti "Libs" w linespoints ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:5 ti "SNP" w linespoints ls 4

	set output "ge2015-diff.png"
	plot '<grep Con ge-data.gp' using 1:5 ti "Tory" w linespoints ls 1,\
	     '<grep Lab ge-data.gp' using 1:5 ti "Labour" w linespoints ls 2,\
	     '<grep Lib ge-data.gp' using 1:5 ti "Libs" w linespoints ls 3
EOF

