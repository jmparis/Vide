#!/bin/bash

# On retire vblank_mode=0 pour laisser le pilote gérer la fluidité naturellement
#unset vblank_mode

export MESA_GL_VERSION_OVERRIDE=4.5FC
export MESA_GLSL_VERSION_OVERRIDE=450
export _JAVA_AWT_WM_NONREPARENTING=1

# On garde la RAM, mais on retire les options de "tuning" agressives
#sudo nice -n -10 java \
java \
    -Xms2G -Xmx4G \
    -XX:+UseG1GC \
    -Djogamp.gluegen.UseTempJarCache=false \
    -Djava.library.path="lib/:lib/jogl/" \
    --enable-native-access=ALL-UNNAMED \
    -cp "dist/Vide.jar:lib/*:lib/jogl/*:lib/swing-layout/*:lib/lwjgl/*" \
    de.malban.VideMain
