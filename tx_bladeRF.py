#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Not titled yet
# GNU Radio version: v3.8.5.0-6-g57bd109d

from gnuradio import blocks
import pmt
from gnuradio import gr
from gnuradio.filter import firdes
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
import osmosdr
import time


class test(gr.top_block):

    def __init__(self, antenna="TX1", filename="/home/parallels/test.raw", freq=2412000000, gain=20):
        gr.top_block.__init__(self, "Not titled yet")

        ##################################################
        # Parameters
        ##################################################
        self.antenna = antenna
        self.filename = filename
        self.freq = freq
        self.gain = gain

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 20000000
        self.bandwidth = bandwidth = 20000000

        ##################################################
        # Blocks
        ##################################################
        self.osmosdr_sink_0 = osmosdr.sink(
            args="numchan=" + str(1) + " " + 'bladerf=0'
        )
        self.osmosdr_sink_0.set_sample_rate(samp_rate)
        self.osmosdr_sink_0.set_center_freq(freq, 0)
        self.osmosdr_sink_0.set_freq_corr(0, 0)
        self.osmosdr_sink_0.set_gain(gain, 0)
        self.osmosdr_sink_0.set_if_gain(20, 0)
        self.osmosdr_sink_0.set_bb_gain(20, 0)
        self.osmosdr_sink_0.set_antenna(antenna, 0)
        self.osmosdr_sink_0.set_bandwidth(bandwidth, 0)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_gr_complex*1, filename, True, 0, 0)
        self.blocks_file_source_0.set_begin_tag(pmt.PMT_NIL)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_file_source_0, 0), (self.osmosdr_sink_0, 0))


    def get_antenna(self):
        return self.antenna

    def set_antenna(self, antenna):
        self.antenna = antenna
        self.osmosdr_sink_0.set_antenna(self.antenna, 0)

    def get_filename(self):
        return self.filename

    def set_filename(self, filename):
        self.filename = filename
        self.blocks_file_source_0.open(self.filename, True)

    def get_freq(self):
        return self.freq

    def set_freq(self, freq):
        self.freq = freq
        self.osmosdr_sink_0.set_center_freq(self.freq, 0)

    def get_gain(self):
        return self.gain

    def set_gain(self, gain):
        self.gain = gain
        self.osmosdr_sink_0.set_gain(self.gain, 0)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.osmosdr_sink_0.set_sample_rate(self.samp_rate)

    def get_bandwidth(self):
        return self.bandwidth

    def set_bandwidth(self, bandwidth):
        self.bandwidth = bandwidth
        self.osmosdr_sink_0.set_bandwidth(self.bandwidth, 0)




def argument_parser():
    parser = ArgumentParser()
    parser.add_argument(
        "--antenna", dest="antenna", type=str, default="TX1",
        help="Set TX Antenna [default=%(default)r]")
    parser.add_argument(
        "--filename", dest="filename", type=str, default="/home/parallels/test.raw",
        help="Set Filename [default=%(default)r]")
    parser.add_argument(
        "--freq", dest="freq", type=intx, default=2412000000,
        help="Set Channel Frequency (Centre) [default=%(default)r]")
    parser.add_argument(
        "--gain", dest="gain", type=intx, default=20,
        help="Set RF Gain [default=%(default)r]")
    return parser


def main(top_block_cls=test, options=None):
    if options is None:
        options = argument_parser().parse_args()
    tb = top_block_cls(antenna=options.antenna, filename=options.filename, freq=options.freq, gain=options.gain)

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()

    tb.wait()


if __name__ == '__main__':
    main()
