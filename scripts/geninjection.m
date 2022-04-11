% Create frame configuration

config = wlanMACManagementConfig;
config.BeaconInterval = 100;
config.SSID = "Moooooo";
config = config.addIE(3, "0B");

macCfg = wlanMACFrameConfig('FrameType', 'Beacon', "ManagementConfig", config);
macCfg.FrameFormat = 'HT';     % Frame format
macCfg.FromDS = 0; % To indicate an AP is sending this (Distributed System)
macCfg.Address1 = "FFFFFFFFFFFF"; % Receiver addr (Must be FFFF for broadcast)
macCfg.Address2 = "0016EA123456"; % Tx
macCfg.Address3 = "0016EA123456"; % Dest
macCfg.Address4 = "0016EA123456"; % BSSID

[mpduBits, mpduLength] = wlanMACFrame(macCfg, "OutputFormat", "bits");
cfgHT = wlanHTConfig(PSDULength=mpduLength);
% cfgHT.MCS = 1;
% cfgHT.GuardInterval = "Short";

idleTime = 200e-6;

txWaveform = wlanWaveformGenerator(mpduBits, cfgHT, "NumPackets", 5, "WindowTransitionTime", 8e-9, "IdleTime", idleTime);

write_complex_binary(txWaveform, "test.raw");
%save_sc16q11("test.sc16q11.demo2", txWaveform);