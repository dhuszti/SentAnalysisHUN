#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys, os, fileinput

for line in fileinput.input():
	pass
	if line.startswith("<w"):
		print line.replace("<w>","").replace("</w>","")#.encode("utf8")
	if line.startswith("</s>"):
		print line.replace("</s>", "thisistheending")#.encode("utf8")


