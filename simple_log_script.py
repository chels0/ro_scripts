#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 24 10:24:36 2022

@author: lauri
"""
from datetime import datetime, date, time, timedelta
import sys

log = sys.argv[1]

with open(log, "r") as f:
    lines = f.readlines()


test5 = []

test7 = []

for i in range(len(lines)):
    if '[' in lines[i]:
        test7.append(lines[i])
        if 'Finished job' in lines[i+1]:
            date_and_time1 = lines[i]
            start = date_and_time1.split()[3]
            start_time = datetime.strptime(start, '%H:%M:%S' )
            job_id = lines[i+1]
            job_id_spl = job_id.split('.')
            repl = job_id_spl[0].replace('Finished job', 'Job')
            test5.append([date_and_time1, repl, start_time])

start_time_string = test7[0].split()[3]
start_time = datetime.strptime(start_time_string, '%H:%M:%S' )

mini = []

for i in range(len(test5)):
        start = test5[i]
        if i == 0:
            diff = start[2] - start_time
            test5[i].append(diff)
            mini.append(diff)
        elif i != len(test5)-1: 
            stop = test5[i+1]
            diff = stop[2]-start[2]
            test5[i].append(diff)
            mini.append(diff)
        else:
            test5[i].append('Stop time unknown')

total_time = test5[len(test5)-1][2] - test5[0][2]

test = [line for line in lines if 'Job' in line]        
del test[0]

test3 = [test2.split(':') for test2 in test]

testt = []

for line2 in test5:
    for line in test3:
        if line[0] == line2[1]:
            testt.append([line[0], line[1], line[2], line2[0], line2[3]])
            
mini.sort()
mini_10 = mini[-10:]

mini_str = [str(times) for times in mini_10]

test = ' '.join(str(mini_10))

with open('test_log.log', 'w') as f:
    f.write('\n\nWorkflow total run time (hours:minutes:seconds): ' + str(total_time) + '\n')
    f.write('___________________________________________________________________________\n')
    f.write('Longest run times: ' + str(max(mini_10)))
    for line in testt:
        f.write("\n%s" % line[3] + ' '+ line[0] + ', run time '+ str(line[4]) + ', ' + line[1] + ': ' + line[2]+ '\n')
        f.write('\n')
            




    
