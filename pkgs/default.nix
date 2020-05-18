self: super: {
  recipesEthMoe = self.callPackage ( builtins.fetchGit { url = "https://github.com/ethulhu/recipes.eth.moe"; } ) {};
}
