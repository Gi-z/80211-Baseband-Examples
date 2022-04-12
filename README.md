# 802.11 Baseband Examples

Example baseband waveforms for template 802.11 frames (Useful for generating CSI streams).

### Caution

This repository is provided for research/educational purposes **ONLY**. Always carefully consider your actions before commencing any **TRANSMIT** operations with a software-defined radio. Consult your local RF regulatory body (OFCOM, FCC, etc) guidelines for License-exempt Short Range Devices before using any of the provided code.

## Background

Capturing CSI with COTS hardware is generally a finicky process. New users are recommended to connect a STA/AP pair, generate traffic using ping, and collect CSI generated for responses. This is the most accessible way to generate a packet stream for CSI capture, since most users are familiar with Managed Mode operation. However by allowing this packet stream to be automatically managed by the AP and STA, inconsistency can arise. Changes in wireless conditions can cause intermittent frame pacing, shifting modulation types (MCS), and other issues which cannot be directly managed in a typical AP/STA pairing. These changes incur a different 802.11 link for which the CSI will not be directly comparable.

While the impact of these inconsistencies is usually minor, for research purposes a consistent stream generation method is preferred. As such, this repository aims to provide example baseband samples which can be replayed/transmitted using any `gr-osmosdr`-compatible SDR* to generate consistent streams of 802.11 frames.

\*: Must be capable of Tx at 2.4GHz/5GHz, with a bandwidth of at least 20MHz. 

## Setup

These scripts require a working GNU Radio (3.8+) installation. The easiest way to install GNU Radio is with [pybombs](https://github.com/gnuradio/pybombs).

## Usage

Test your configuration by transmitting a beacon frame:

```console
python tx_{bladeRF/uhd/hackRF/soapy}.py --freq 2412m
```

Once you've confirmed you can transmit the default example, specify a sample from the relevant samples directory, like so:

```console
python tx_bladeRF.py --freq 2412m samples/HT/beacon_mcs4_sgi.raw
```

## Customisation

You can customise the frames provided to suit your purposes. For example, the Intel 5300 NIC will only receive CSI for frames whose source *and* destination MAC addresses match the 5300 magic MAC (00:16:ea:12:34:56).

## References

- **[Linux 802.11n CSI Tool](https://dhalperi.github.io/linux-80211n-csitool/)**: CSI extraction suite for Intel IWL5300 hardware.
  - This project was released by [Daniel Halperin](http://github.com/dhalperi).
- **[MATLAB WLAN Toolbox](https://uk.mathworks.com/products/wlan.html)**: Library for WLAN waveform generation.
