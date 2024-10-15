{pkgs, inputs, ...}: {
  services.blocky = {
    enable = true;
    settings = {
      log.level = "warn";
      connectIPVersion = "v4";
      ports.dns = 53;
      ports.http = "127.0.0.1:4000";
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };
      #Enable Blocking of certian domains.
      blocking = {
        blockType = "ZEROIP";
        loading.strategy = "fast";
        denylists = {
          tracking = [
            "https://v.firebog.net/hosts/Easyprivacy.txt"
            "https://v.firebog.net/hosts/Prigent-Ads.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
            "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
            "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
            "https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt"
            "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt"
            "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt"
            "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt"
            "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt"
          ];
          ads = [
            "https://adaway.org/hosts.txt"
            "https://v.firebog.net/hosts/AdguardDNS.txt"
            "https://v.firebog.net/hosts/Admiral.txt"
            "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
            "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
            "https://v.firebog.net/hosts/Easylist.txt"
            "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
            "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
            "https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts"
          ];
        };
        clientGroupsBlock = {
          default = [             
            "ads"
            "tracking" 
          ];
        };
      };
      hostsFile = {
        sources = [ "/etc/hosts" ];
        hostsTTL = "1h";
        loading = {
          refreshPeriod = "30m";
          strategy = "fast";
        };
      };
      caching = {
        minTime = "1h";
        maxTime = "24h";
        prefetching = true;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  networking = {
    networkmanager = {
      insertNameservers = ["127.0.0.1"];
    };
  };
}
