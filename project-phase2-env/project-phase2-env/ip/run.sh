#!/bin/bash

echo Run dff_tb
iverilog -g2012 dv/dff_tb.v dff.v && vvp a.out -fst

echo Run pldff_tb
iverilog -g2012 dv/pldff_tb.v pldff.v && vvp a.out -fst
