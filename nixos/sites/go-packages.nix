{ pkgs }:
with pkgs.lib;

let
  mkLocation = virtualHost: module: url: {
    name = "/${module}";
    value = {
      extraConfig = ''
        if ($args = "go-get=1") {
          add_header Content-Type text/html;
          return 200 '<meta name="go-import" content="${virtualHost}/${module} git ${url}">';
        }
        return 302 ${url};
      '';
    };
  };

in { virtualHost, modules }: {
  locations = listToAttrs (mapAttrsToList (mkLocation virtualHost) modules);
}
