{ vesktop, electron, ... }:

vesktop.overrideAttrs (old: {
  preBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  '';
  buildPhase = ''
    runHook preBuild

    pnpm build
    pnpm exec electron-builder \
      --dir \
      -c.asarUnpack="**/*.node" \
      -c.electronDist="electron-dist" \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';
})
