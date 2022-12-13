set ns [new Simulator]
$ns color 1 red
$ns color 2 blue
$ns rtproto DV
set nf [open out.nam w]
$ns namtrace-all $nf
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam
	exit 0
}

for { set i 0 } {$i<3} {incr i} {
	set n($i) [$ns node]
	}
for { set i 1} {$i<3} {incr i} {
	$ns duplex-link $n(0) $n($i) 512kb 10ms SFQ
	}
	
$ns duplex-link-op $n(0) $n(1) orient right
$ns duplex-link-op $n(0) $n(2) orient left

set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$ns attach-agent $n(1) $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n(2) $sink0

$ns connect $tcp0 $sink0

#FTP Config
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0


$ns rtmodel-at 1 down $n(0) $n(2)
$ns rtmodel-at 1.5 up $n(0) $n(2)

$ns at 0.1 "$ftp0 start"
$ns at 0.9 "$ftp0 stop"
$ns at 2.0 "finish"
$ns run
