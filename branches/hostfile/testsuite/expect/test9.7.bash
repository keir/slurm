#!/bin/bash
############################################################################
# Simple SLURM stress test
# Usage: <prog> <exec1> <exec2> <exec3> <sleep_time> <iterations>
# Default is sinfo, srun, squeue, 1 second sleep and 3 iterations
############################################################################
# Copyright (C) 2002 The Regents of the University of California.
# Produced at Lawrence Livermore National Laboratory (cf, DISCLAIMER).
# Written by Morris Jette <jette1@llnl.gov>
# UCRL-CODE-2002-040.
# 
# This file is part of SLURM, a resource management program.
# For details, see <http://www.llnl.gov/linux/slurm/>.
#  
# SLURM is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
# 
# SLURM is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
# 
# You should have received a copy of the GNU General Public License along
# with SLURM; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.
############################################################################
if [ $# -gt 0 ]; then
	exec1=$1
else
	exec1="sinfo"
fi
if [ $# -gt 1 ]; then
	exec2=$2
else
	exec2="srun"
fi
if [ $# -gt 2 ]; then
	exec3=$3
else
	exec3="squeue"
fi
if [ $# -gt 3 ]; then
	sleep_time=$4
else
	sleep_time=1
fi

if [ $# -gt 4 ]; then
	iterations=$5
else
	iterations=3
fi

exit_code=0
inx=1
log="test9.7.$$.output"
touch $log
while [ $inx -le $iterations ]
do
	echo "########## LOOP $inx ########## " >>$log 2>&1
	$exec1                                  >>$log 2>&1
	rc=$?
	if [ $rc -ne 0 ]; then
		exit_code=$rc
	fi
	sleep $sleep_time
	$exec2 -N1-$inx -n$inx -O -s -l hostname         >>$log 2>&1
	rc=$?
	if [ $rc -ne 0 ]; then
		exit_code=$rc
	fi
	sleep $sleep_time
	$exec3                                  >>$log 2>&1
	rc=$?
	if [ $rc -ne 0 ]; then
		exit_code=$rc
	fi
	sleep $sleep_time
	inx=$((inx+1))
done

if [ $exit_code -ne 0 ]; then
	cat $log
fi
rm $log
echo "########## EXIT_CODE $exit_code ########## "
exit $exit_code
