function v = generate_beacon_vht(filename, mcs, sgi)

    % Create frame configuration
    
    config = wlanMACManagementConfig;
    config.SSID = "80211_VHT_BEACON_EXAMPLE";
    
    % Beacon specifics.
    %config.BeaconInterval = 100; % number of time units (1TU = 1024us)
    %config = config.addIE(3, "0B"); % 802.11 WLAN channel in hex
    
    macCfg = wlanMACFrameConfig('FrameType', 'Beacon', "ManagementConfig", config);
    macCfg.FrameFormat = 'HT';     % Frame format
    macCfg.FromDS = 0; % To indicate an "AP" is sending this (Distributed System)
    macCfg.Address1 = "FFFFFFFFFFFF"; % Receiver addr (Must be FFFF for broadcast)
    macCfg.Address2 = "0016EA123456"; % Tx
    macCfg.Address3 = "0016EA123456"; % Dest
    macCfg.Address4 = "0016EA123456"; % BSSID
    
    [mpduBits, mpduLength] = wlanMACFrame(macCfg, "OutputFormat", "bits");
    cfgHT = wlanHTConfig(PSDULength=mpduLength);

    cfgHT.MCS = mcs;

    if (sgi)
        cfgHT.GuardInterval = "Short";
    else
        cfgHT.GuardInterval = "Long";
    end
    
    idleTime = 200e-6;
    
    txWaveform = wlanWaveformGenerator(mpduBits, cfgHT, "NumPackets", 5, "WindowTransitionTime", 8e-9, "IdleTime", idleTime);
    
    write_complex_binary(txWaveform, filename);
end