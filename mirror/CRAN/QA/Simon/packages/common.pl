#!/usr/bin/perl

@dnames=('0','1','2','3','cheetah','puma','jaguar','panther','tiger','leopard','snowleopard');

$root='/Builds/packages';
$osver=`uname -r`;
$oscode=lc(`uname`);
$oscode=$dnames[$1] if ($osver=~/^(\d+)/);
$target="$oscode-universal";
$fver=$ver=`R --version|sed -n 's/R version //p'`;
$fver=$1 if ($fver=~/^(\d+\.\d+\.\d+)/);
$ver=$1 if ($ver=~/^(\d+\.\d+)/);

