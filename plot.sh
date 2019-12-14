#!/bin/bash

awk '{vote=$4; seats=$5/$6*100; delta=seats-vote; print $1,$2,$3,vote, seats, delta}' ge-data > ge-data.gp
awk '{vote=$4; seats=$5/$6*100; delta=seats-vote; print $1,$2,$3,vote, seats, delta}' ge-data-scotland > ge-data-scotland.gp

electiondate=20191212
xaxis_end=20241212
GP_PREAMBLE='
	set xdata time
	set timefmt "%Y%m%d"

	set grid
	set border 3
	set tics nomirror
	set xtics rotate
	set ytics -100,10
	set xtics("19700618", "19740228", "19741010", "19790503", "19830609", "19870611", "19920409", "19970501", "20010607", "20050505", "20100506", "20150507", "20170608", "20191212", "20241212")

	set xrange ["19700618":"'$xaxis_end'"]

	set linestyle 1 lt 1 lw 2 lc rgb "#0645AD" pt 7 ps 0.75;
	set linestyle 2 lt 1 lw 2 lc rgb "#DC241F" pt 7 ps 1;
	set linestyle 3 lt 1 lw 2 lc rgb "#FE8301" pt 7 ps 1;
	set linestyle 4 lt 1 lw 2 lc rgb "#EBC31C" pt 7 ps 1;
	set linestyle 9 lt 1 lw 2 lc rgb "#000000" pt 7 ps 1;

	set style fill noborder

	set key horiz at screen 0.5, 0.965 center
'

gnuplot <<EOF
	set term pngcairo size 1000,400 dashed
	$GP_PREAMBLE

	set ylabel "UK popular vote"
	set ytics 0,1000000

	set arrow from "$electiondate",0 to "$electiondate",20000000 nohead lc rgb "red"
	set arrow from "19700618",50 to "$xaxis_end",50 nohead lc rgb 'black'

	set format x "%b %Y"
	set output "ge-uk-popvote.png"
	plot '<grep Con ge-data.gp' using 1:3 ti "Conservative" w fsteps ls 1,\
	     '<grep Lab ge-data.gp' using 1:3 ti "Labour" w fsteps ls 2,\
	     '<grep Lib ge-data.gp' using 1:3 ti "Lib Dems" w fsteps ls 3,\
	     '<grep SNP ge-data.gp' using 1:3 ti "SNP" w fsteps ls 4

	#set size 0.99,0.47
	#set origin 0.01,0.48
	set ylabel "Scottish popular vote"

	set ytics 0,250000
	# remove xtic labels
	set format x ""
	set output "ge-sc-popvote.png"
	plot '<grep Con ge-data-scotland.gp' using 1:3 ti "Conservative" w fsteps ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:3 ti "Labour" w fsteps ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:3 ti "Lib Dems" w fsteps ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:3 ti "SNP" w fsteps ls 4
EOF

gnuplot <<EOF
	set term pngcairo size 1000,800 dashed
	$GP_PREAMBLE

	set output "ge-uk.png"
	set multiplot

	set size 0.99,0.47
	set origin 0.01,0.01
	set yrange [0:100]
	set ylabel "UK seat share (%)"

	set arrow from "$electiondate",0 to "$electiondate",100 nohead lc rgb "red"
	set arrow from "19700618",50 to "$xaxis_end",50 nohead lc rgb 'black'

	set format x "%b %Y"
	plot '<grep Con ge-data.gp' using 1:5 ti "Conservative" w fsteps ls 1,\
	     '<grep Lab ge-data.gp' using 1:5 ti "Labour" w fsteps ls 2,\
	     '<grep Lib ge-data.gp' using 1:5 ti "Lib Dems" w fsteps ls 3,\
	     '<grep SNP ge-data.gp' using 1:5 ti "SNP" w fsteps ls 4

	set size 0.99,0.47
	set origin 0.01,0.48
	set ylabel "UK vote share (%)"

	# remove xtic labels
	set format x ""
	plot '<grep Con ge-data.gp' using 1:4 ti "Conservative" w fsteps ls 1,\
	     '<grep Lab ge-data.gp' using 1:4 ti "Labour" w fsteps ls 2,\
	     '<grep Lib ge-data.gp' using 1:4 ti "Lib Dems" w fsteps ls 3,\
	     '<grep SNP ge-data.gp' using 1:4 ti "SNP" w fsteps ls 4
EOF

gnuplot <<EOF
	set term pngcairo size 1000,800 dashed
	$GP_PREAMBLE

	set output "ge-sc.png"
	set multiplot

	set size 0.99,0.47
	set origin 0.01,0.01
	set yrange [0:100]
	set ylabel "Scottish seat share (%)"

	set arrow from "$electiondate",0 to "$electiondate",100 nohead lc rgb "red"
	set arrow from "19700618",50 to "$xaxis_end",50 nohead lc rgb 'black'

	# remove xtic labels
	set format x "%b %Y"
	plot '<grep Con ge-data-scotland.gp' using 1:5 ti "Conservative" w fsteps ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:5 ti "Labour" w fsteps ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:5 ti "Lib Dems" w fsteps ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:5 ti "SNP" w fsteps ls 4

	set size 0.99,0.47
	set origin 0.01,0.48
	set ylabel "Scottish vote share (%)"
	set format x ""
	plot '<grep Con ge-data-scotland.gp' using 1:4 ti "Conservative" w fsteps ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:4 ti "Labour" w fsteps ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:4 ti "Lib Dems" w fsteps ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:4 ti "SNP" w fsteps ls 4
EOF

gnuplot <<EOF
	set term pngcairo size 1000,400 dashed
	$GP_PREAMBLE

	set size 0.99,0.96
	set origin 0.01,0.01
	set arrow from "$electiondate",-50 to "$electiondate",50 nohead lc rgb "red"
	set arrow from "19700618",0 to "$xaxis_end",0 nohead lc rgb "black"
	set yrange [-50:50]
	set format x "%b %Y"

	set ylabel "% difference, votes to seat share (Scotland)"
	set output "ge-sc-diff.png"
	plot '<grep Con ge-data-scotland.gp' using 1:6 ti "Conservative" w fsteps ls 1,\
	     '<grep Lab ge-data-scotland.gp' using 1:6 ti "Labour" w fsteps ls 2,\
	     '<grep Lib ge-data-scotland.gp' using 1:6 ti "Lib Dems" w fsteps ls 3,\
	     '<grep SNP ge-data-scotland.gp' using 1:6 ti "SNP" w fsteps ls 4

	set ylabel "% difference, votes to seat share (UK)"
	set output "ge-uk-diff.png"
	plot '<grep Con ge-data.gp' using 1:6 ti "Conservative" w fsteps ls 1,\
	     '<grep Lab ge-data.gp' using 1:6 ti "Labour" w fsteps ls 2,\
	     '<grep Lib ge-data.gp' using 1:6 ti "Lib Dems" w fsteps ls 3,\
	     '<grep SNP ge-data.gp' using 1:6 ti "SNP" w fsteps ls 4
EOF

