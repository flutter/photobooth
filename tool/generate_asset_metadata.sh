#!/bin/bash

# Script used to analyze bundled assets and generate a dart file which contains
# the relevant metadata needed at runtime without forcing the application to
# download the assets.
#
# Usage:
# ./tool/generate_asset_metadata.sh > lib/assets.g.dart

set -e

output_metadata () {
    width=$(sips -g pixelWidth $1 | tail -n1 | cut -d" " -f4)
    height=$(sips -g pixelHeight $1 | tail -n1 | cut -d" " -f4)
    filepath=$1
    name=$(basename "${filepath%.*}")

    echo "Asset(name: '$name', path: '$1', size: Size($width, $height));"
}

echo "// GENERATED CODE - DO NOT MODIFY BY HAND"
echo ""
echo "import 'package:flutter/widgets.dart';"
echo "import 'package:photobooth_ui/photobooth_ui.dart';"
echo ""
echo "class Assets {"

characters=("android.png" "dash.png" "dino.png" "sparky.png")

for character in "${characters[@]}"
do
    path="assets/images/$character"
    width=$(sips -g pixelWidth $path | tail -n1 | cut -d" " -f4)
    height=$(sips -g pixelHeight $path | tail -n1 | cut -d" " -f4)    
    name=$(basename "${path%.*}")
    echo "  static const $name = Asset(name: '$name', path: '$path', size: Size($width, $height),);"
done

googleProps=assets/props/google/*.png

echo "  static const googleProps = {"
for prop in $googleProps
do    
    width=$(sips -g pixelWidth $prop | tail -n1 | cut -d" " -f4)
    height=$(sips -g pixelHeight $prop | tail -n1 | cut -d" " -f4)    
    name=$(basename "${prop%.*}")
    echo "    Asset(name: '$name', path: '$prop', size: Size($width, $height),),"
done

echo "  };"

hatProps=assets/props/hats/*.png

echo "  static const hatProps = {"
for prop in $hatProps
do    
    width=$(sips -g pixelWidth $prop | tail -n1 | cut -d" " -f4)
    height=$(sips -g pixelHeight $prop | tail -n1 | cut -d" " -f4)    
    name=$(basename "${prop%.*}")
    echo "    Asset(name: '$name', path: '$prop', size: Size($width, $height),),"
done

echo "  };"

eyewearProps=assets/props/eyewear/*.png

echo "  static const eyewearProps = {"
for prop in $eyewearProps
do    
    width=$(sips -g pixelWidth $prop | tail -n1 | cut -d" " -f4)
    height=$(sips -g pixelHeight $prop | tail -n1 | cut -d" " -f4)    
    name=$(basename "${prop%.*}")
    echo "    Asset(name: '$name', path: '$prop', size: Size($width, $height),),"
done

echo "  };"

foodProps=assets/props/food/*.png

echo "  static const foodProps = {"
for prop in $foodProps
do    
    width=$(sips -g pixelWidth $prop | tail -n1 | cut -d" " -f4)
    height=$(sips -g pixelHeight $prop | tail -n1 | cut -d" " -f4)    
    name=$(basename "${prop%.*}")
    echo "    Asset(name: '$name', path: '$prop', size: Size($width, $height),),"
done

echo "  };"

shapeProps=assets/props/shapes/*.png

echo "  static const shapeProps = {"
for prop in $shapeProps
do    
    width=$(sips -g pixelWidth $prop | tail -n1 | cut -d" " -f4)
    height=$(sips -g pixelHeight $prop | tail -n1 | cut -d" " -f4)    
    name=$(basename "${prop%.*}")
    echo "    Asset(name: '$name', path: '$prop', size: Size($width, $height),),"
done

echo "  };"

echo "  static const props = {...googleProps, ...eyewearProps, ...hatProps, ...foodProps, ...shapeProps};"

echo "}"