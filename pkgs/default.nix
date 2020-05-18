self: super: {
  eth = {
    recipesEthMoe = self.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/recipes.eth.moe"; } ) {};
  };
}
