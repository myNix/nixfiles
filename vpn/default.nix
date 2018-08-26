{ config, lib, pkgs, ... }:

{
  services = {
    openvpn.servers = {
      scaleway = {
        config = '' config /etc/nixos/vpn/vpn-work-mvaude.ovpn '';
        autoStart = true;
        updateResolvConf = true;
        # up = "echo ragnaros $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
        # down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
      };
    };
  };
}
