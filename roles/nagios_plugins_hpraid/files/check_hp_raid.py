#!/usr/bin/env python
#coding: utf8

import sys
import getopt
from subprocess import *
import shlex

# Get Options
magic_number = 0

try:
  opts, args = getopt.getopt(sys.argv[1:],"hm:",["magic_number="])
except getopt.GetoptError:
  print 'Usage: check_hp_raid [-m <N> | --magic_number <N>]'
  sys.exit(2)

if opts == []:
    print 'Usage: check_hp_raid [-m <N> | --magic_number <N>]'
    sys.exit(2)

for opt, arg in opts:
  if opt == '-h':
     print 'Usage: check_hp_raid [-m <N> | --magic_number <N>]'
     sys.exit()
  elif opt in ("-m", "--magic_number"):
     magic_number = arg













# run commands in shell 
# check_output(): New in version 2.7.
#status_number=check_output("hpssacli ctrl all show config detail | grep ' OK' | wc -l", shell=True)
#status_short=check_output("hpssacli ctrl all show status", shell=True)


try:
    # Full status
    # "hpssacli ctrl all show config detail | grep ' OK' | wc -l"
    command_line = "hpssacli ctrl all show config detail"
    args = shlex.split(command_line)
    p1 = Popen(args, stdout=PIPE)
    p2 = Popen(["grep", " OK"], stdin=p1.stdout, stdout=PIPE)
    p3 = Popen(["wc", "-l"], stdin=p2.stdout, stdout=PIPE)
    p1.stdout.close()  # Allow p1 to receive a SIGPIPE if p3 exits.
    p2.stdout.close()  # Allow p2 to receive a SIGPIPE if p3 exits.
    status_number = p3.communicate()[0]

    #print 'Status number is', status_number




    # Short status
    # "hpssacli ctrl all show status"
    command_line = "hpssacli ctrl all show status"
    args = shlex.split(command_line)
    p1 = Popen(args, stdout=PIPE)
    status_short = p1.communicate()[0]

    #print 'Short status is', status_short
except Exception as e_inst:
    status = str(e_inst)
    print "HP_RAID CRITICAL: %s" % status
    sys.exit(2)




# Compile status info
#status_short.split('\n')
status = status_short.replace('\n',' ')









# Logic
if int(status_number) == int(magic_number):
    print "HP_RAID OK: %s" % status
    sys.exit(0)
else:
    print "HP_RAID CRITICAL: %s" % status
    sys.exit(2)

