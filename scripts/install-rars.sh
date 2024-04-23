DOWNLOAD_URL="https://github.com/TheThirdOne/rars/releases/download/v1.6/rars1_6.jar"

mkdir -p bin
curl -Lo bin/rars.jar $DOWNLOAD_URL &> /dev/null
echo "=> RARS binary installed into $PWD/bin/rars.jar"
