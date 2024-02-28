#!/bin/bash
#export JAVA_HOME=/usr/java/jdk1.8.0_321-amd64/
export ECLIPSE_HOME=/path/
export ANT_HOME=/path/ant
# The BUILD_SCRIPT contains the build specific Ant tasks which run during the

#Dir where the cartridges are found
cartridgeName=""
cartridgeDir="path/"
buildFile="path/build-file.xml"
deployDir="/path"
parFile="/path/prj"

export BUILD_SCRIPT=scripts/build-script.xml

#Deploy cartrige
Deploy(){
        $ANT_HOME/bin/ant -file scripts/build.xml -DBUILD_SCRIPT=$BUILD_SCRIPT
        sed -i "s/$cartridgeName/cartridgeName/g" $buildFile
	echo "trying to copy $cartridgeName.par into $deployDir"
        sleep 1
        cp $parFile/$cartridgeName/cartridgeBin/$cartridgeName.par $deployDir/$cartridgeName.par
}

#List of cartriges
List(){
        echo "Cartridges avaliable in $cartridgeDir"
        for fileName in $(ls $cartridgeDir); do
                echo "- $fileName"
        done
}

#Menu of options
Menu(){
        echo "
        Arguments avaliable:
        -l : List all the proyects avaliable (./build.sh -l) .
        -d : Build specified cartridge (./build.sh -d cartridgeName).
        "
}
while [ True ]; do
        if [ "$1" = "--list" -o "$1" = "-l" ]; then
                List
                break
        elif [ "$1" = "--deploy" -o "$1" = "-d" ]; then
                shift
                cartridgeName="$1"
                echo "Cartridge name received : $cartridgeName"
		echo "Editing file $buildFile.."
		sed -i "s/cartridgeName/$cartridgeName/g" $buildFile
                Deploy
                break
        else
                Menu
                break
        fi
done
