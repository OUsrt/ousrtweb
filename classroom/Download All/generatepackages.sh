#!/bin/bash
# This code handles the compilation of all classroom sources
# Probably could be handled better but works

###################################
# part 1 generates the tar.gz file
###################################

# store current working directory
CWD=`pwd`
# find absolute path of script
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

# move to thhis directory
cd "$BASEDIR"
cd ..

NWD=`pwd`
NWD="$NWD"

# make sure temporary directory is not made (ensures no recursion)
if [[ -d "$NWD/allprojects" && ! -L "$NWD/allprojects" ]]; then
    echo "Please migrate or remove $NWD/allprojects"
    exit 0
fi

# create directory and tmp json file
mkdir "$NWD/allprojects"
json="$BASEDIR/../../classroom.json"
if [ -f "$json" ]; then
    rm -f "$json"
fi

touch "$json"
echo "{" >> "$json"
echo "  \"modules\": [" >> "$json"

# copy files to this new directory for archiving: prevents recursion
for f in *; do
    if [ -d "$f" ] && [ ! -L "$f" ] && [ "$f" != "allprojects" ] && [ "$f" != "Download All" ] && [ "$f" != "Manuals" ] && [ "$f" != "Codes" ]; then
        # handles json file
        echo "    {" >> "$json"
        DESC=`head -n 20 "$f/README.md" | grep "DESC"`
        DESC="${DESC:5}"
        echo "      \"desc\": \"$DESC\"," >> "$json"
        echo "      \"name\": \"$f\"," >> "$json"
        echo "      \"data\": \"$f/exampledata.tar.gz\"," >> "$json"
        echo "      \"instructor\": \"$f/instructor.tar.gz\"," >> "$json"
        echo "      \"directions\": \"$f/README.md\"," >> "$json"
        echo "      \"bkgnd\": \"$f/bkgnd.jpg\"" >> "$json"
        echo "    }," >> "$json"
        # copies all files to allprojects
        cp -r "$f" "$NWD/allprojects/"
    fi
    if [ -d "$f" ] && [ ! -L "$f" ] && [ "$f" == "Download All" ]; then
        # handles json file
        echo "    {" >> "$json"
        DESC=`head -n 20 "$f/README.md" | grep "DESC"`
        DESC="${DESC:5}"
        echo "      \"desc\": \"$DESC\"," >> "$json"
        echo "      \"name\": \"$f\"," >> "$json"
        echo "      \"data\": \"$f/allprojects.tar.gz\"," >> "$json"
        echo "      \"instructor\": \"\"," >> "$json"
        echo "      \"directions\": \"$f/README.md\"," >> "$json"
        echo "      \"bkgnd\": \"$f/bkgnd.jpg\"" >> "$json"
        echo "    }," >> "$json"
        # copies all files to allprojects
        cp -r "$f" "$NWD/allprojects/"
    fi
    if [ -d "$f" ] && [ ! -L "$f" ] && [ "$f" == "Manuals" ]; then
        # handles json file
        echo "    {" >> "$json"
        DESC=`head -n 20 "$f/README.md" | grep "DESC"`
        DESC="${DESC:5}"
        echo "      \"desc\": \"$DESC\"," >> "$json"
        echo "      \"name\": \"$f\"," >> "$json"
        echo "      \"data\": \"https://github.com/OUsrt/SRTmanuals/archive/master.zip\"," >> "$json"
        echo "      \"instructor\": \"\"," >> "$json"
        echo "      \"directions\": \"$f/README.md\"," >> "$json"
        echo "      \"bkgnd\": \"$f/bkgnd.jpg\"" >> "$json"
        echo "    }," >> "$json"
        # copies all files to allprojects
        cp -r "$f" "$NWD/allprojects/"
    fi
    if [ -d "$f" ] && [ ! -L "$f" ] && [ "$f" == "Codes" ]; then
        # handles json file
        echo "    {" >> "$json"
        DESC=`head -n 20 "$f/README.md" | grep "DESC"`
        DESC="${DESC:5}"
        echo "      \"desc\": \"$DESC\"," >> "$json"
        echo "      \"name\": \"$f\"," >> "$json"
        echo "      \"data\": \"https://github.com/OUsrt/SRTscripts/archive/master.zip\"," >> "$json"
        echo "      \"instructor\": \"\"," >> "$json"
        echo "      \"directions\": \"$f/README.md\"," >> "$json"
        echo "      \"bkgnd\": \"$f/bkgnd.jpg\"" >> "$json"
        echo "    }," >> "$json"
        # copies all files to allprojects
        cp -r "$f" "$NWD/allprojects/"
    fi
done
sed -i "$ s/},/}/g" "$json"
echo "  ]" >> "$json"
echo "}" >> "$json"

# archiving
tar -czf "allprojects.tar.gz" "allprojects"

mv "$NWD/allprojects.tar.gz" "$BASEDIR/"

# cleaning up
rm -rf "$NWD/allprojects"

echo "Successfully made $NWD/allprojects.tar.gz"
echo "Successfully made $json"

cd "$CWD"
exit 0
