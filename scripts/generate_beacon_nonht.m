function generate_beacon_nonht(varargin)

    p = inputParser;

    % wlanMACManagementConfig options
    addParameter(p, 'SSID', "80211_NONHT_BEACON_EXAMPLE", @isstring);
    addParameter(p, 'WLANChannel', 1);

    % wlanNonHTConfig options
    addParameter(p, 'MCS', 0);

    % wlanMACFrameConfig options
    addParameter(p, 'BSSID', "0016EA123456", @isstring);
    addParameter(p, 'DestAddr', "0016EA123456", @isstring);
    addParameter(p, 'TxAddr', "0016EA123456", @isstring);
    
    % wlanWaveformGenerator options
    addParameter(p, 'NumPackets', 1);
    addParameter(p, 'WindowTransitionTime', 1e-7, @isnumeric);
    addParameter(p, 'IdleTime', 200e-6, @isnumeric);

    % write_complex_binary options
    addParameter(p, 'Filename', "output.raw", @isstring);
    parse(p, varargin{:});

    % This is not a complex script.
    
    config = wlanMACManagementConfig;
    config.SSID = p.Results.SSID;
    
    % Beacon specifics.
    %config.BeaconInterval = 100; % number of time units (1TU = 1024us)
    config = config.addIE(3, dec2hex(p.Results.WLANChannel, 2)); % 802.11 WLAN channel in hex
    
    macCfg = wlanMACFrameConfig('FrameType', 'Beacon', "ManagementConfig", config);
    macCfg.FrameFormat = 'Non-HT'; 
    macCfg.FromDS = 0; % To indicate an "AP" is sending this (Distributed System)
    macCfg.Address1 = "FFFFFFFFFFFF"; % Receiver addr (Must be FFFF for broadcast)
    macCfg.Address2 = p.Results.TxAddr; % Tx
    macCfg.Address3 = p.Results.DestAddr; % Dest
    macCfg.Address4 = p.Results.BSSID; % BSSID
    
    [pduBits, pduLength] = wlanMACFrame(macCfg, "OutputFormat", "bits");
    cfgNonHT = wlanNonHTConfig(PSDULength=pduLength);

    % supported MCS range (0 - 7)
    cfgNonHT.MCS = p.Results.MCS;
    
    txWaveform = wlanWaveformGenerator(pduBits, cfgNonHT, ...
        "NumPackets", p.Results.NumPackets, ...
        "WindowTransitionTime", p.Results.WindowTransitionTime, ...
        "IdleTime", p.Results.IdleTime ...
    );
    
    scaled_waveform = txWaveform / max(txWaveform);
    
    write_complex_binary(scaled_waveform, p.Results.Filename);
end