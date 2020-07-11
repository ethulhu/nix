{ pkgs }:

{ mosquittoHost, mosquittoPort }: {
  locations = {
    "/" = {
      root = "${pkgs.eth.catbus-web-ui}";
    };

    "/mqtt" = {
      proxyPass = "http://${mosquittoHost}:${toString mosquittoPort}";
      proxyWebsockets = true;
      extraConfig = ''
        rewrite ^/mqtt$ / break;
        rewrite ^/mqtt(.*)$ $1 break;
      '';
    };
  };
}
