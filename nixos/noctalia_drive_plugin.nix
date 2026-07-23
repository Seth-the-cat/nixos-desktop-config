{ config, pkgs, lib, ... }:

let
  targetUser = "seththecat"; 
  driveHealthSrc = (pkgs.fetchFromGitHub {
    owner = "noctalia-dev";
    repo  = "community-plugins";
    rev   = "main";
    hash  = "sha256-lW5m/jeUh3NaGam38jZmppirUQjNt20UcGkdlwq2GU0="; 
  }) + "/drive-health";
in
{
  systemd.services.noctalia-drive-health = {
    description = "Collect read-only SMART data for Noctalia Drive Health";
    after = [ "local-fs.target" ];
    path = [ pkgs.smartmontools pkgs.util-linux ]; 
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/sh ${driveHealthSrc}/scripts/collect_raw.sh --output /run/noctalia-drive-health/raw.json";
      Group = config.users.users.${targetUser}.group;
      RuntimeDirectory = "noctalia-drive-health";
      RuntimeDirectoryMode = "0750";
      RuntimeDirectoryPreserve = "yes";
      UMask = "0027";
      StandardOutput = "null";
      StandardError = "journal";
      TimeoutStartSec = "60s";
      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateNetwork = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      RestrictAddressFamilies = [ "AF_UNIX" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      CapabilityBoundingSet = [ "CAP_DAC_OVERRIDE" "CAP_SYS_ADMIN" "CAP_SYS_RAWIO" ];
      ReadWritePaths = [ "/run/noctalia-drive-health" ];
    };
  };

  systemd.timers.noctalia-drive-health = {
    description = "Refresh SMART data for Noctalia";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "20s";
      OnUnitActiveSec = "30s";
      AccuracySec = "5s";
    };
  };

  # smart-action.sh (short/long self-test trigger) as a system tool
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "noctalia-smart-action";
      runtimeInputs = [ pkgs.smartmontools pkgs.util-linux ];
      text = ''exec sh ${driveHealthSrc}/packaging/smart-action.sh "$@"'';
    })
  ];
}
