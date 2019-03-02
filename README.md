# Ben's dotfiles

### Usage:

```bash
git clone https://github.com/ben-z/dotfiles.git
cd dotfiles
make
```

### Misc notes
##### zsh timing script
```bash
rm -f /Users/ben/.zgen/init.zsh && for i in $(seq 1 10); do ts=$(/run/current-system/sw/bin/gdate +%s%6N) ; /run/current-system/sw/bin/zsh -i -c exit ; tt=$(($(/run/current-system/sw/bin/gdate +%s%6N) - $ts)) ; echo "Time taken: $tt microseconds"; done;
```

##### Accessing darwin-rebuild with only nix
```bash
. /Users/ben/.nix-profile/etc/profile.d/nix.sh # source nix
export NIX_PATH=nixpkgs=$HOME/Projects/nixpkgs:darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:darwin=$HOME/Projects/nix-darwin # add nix paths
$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch # build nix-darwin and run darwin-rebuild
```
