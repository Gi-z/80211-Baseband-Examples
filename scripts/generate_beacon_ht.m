function generate_beacon_ht(varargin)

    p = inputParser;

    % wlanMACManagementConfig options
    addParameter(p, 'SSID', "80211_HT_BEACON_EXAMPLE", @isstring);
    addParameter(p, 'WLANChannel', 1);

    % wlanNonHTConfig options
    addParameter(p, 'MCS', 0);
    addParameter(p, 'ShortGuardInterval', false);

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
    config = config.addIE(3, dec2hex(p.Results.WLANChannel, 2)); 
        % 802.11 WLAN channel in hex.
        % Does not have to be correct for devices to parse.
    
    macCfg = wlanMACFrameConfig('FrameType', 'Beacon', "ManagementConfig", config);
    macCfg.FrameFormat = 'HT';
    macCfg.FromDS = 0; % To indicate an "AP" is sending this (Distributed System)
    macCfg.Address1 = "FFFFFFFFFFFF"; % Receiver addr (Must be FFFF for broadcast)
    macCfg.Address2 = p.Results.TxAddr; % Tx
    macCfg.Address3 = p.Results.DestAddr; % Dest
    macCfg.Address4 = p.Results.BSSID; % BSSID
    
    [mpduBits, mpduLength] = wlanMACFrame(macCfg, "OutputFormat", "bits");
    cfgHT = wlanHTConfig(PSDULength=mpduLength);

    % supported MCS range (0 - 31)
    cfgHT.MCS = p.Results.MCS;

    if (p.Results.ShortGuardInterval)
        cfgHT.GuardInterval = "Short";
    end
    
    txWaveform = wlanWaveformGenerator(mpduBits, cfgHT, ...
        "NumPackets", p.Results.NumPackets, ...
        "WindowTransitionTime", p.Results.WindowTransitionTime, ...
        "IdleTime", p.Results.IdleTime ...
    );
    
    write_complex_binary(txWaveform, p.Results.Filename);
end