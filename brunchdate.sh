releases_url="https://dl.google.com/dl/edgedl/chromeos/recovery/recovery.json"
UPDATEID=$RANDOM
echo This update has an update code of $UPDATEID
cd ~/Downloads
[ -n "$(uname -m | grep "i.*86")" ] && { echo "ERROR: your device CPU is x86. Latest brunch is incompatible with x86.)"; exit 1; }
mkdir "UPDATE_$UPDATEID"
cd "UPDATE_$UPDATEID"

curl $releases_url -o releases.json 
string="$(grep -o '"url":.*/chromeos_.*_'${board}'_.*.bin\..*"' recovery.json | sort -V | tail -n 1)"
info_string="$(grep -A 6 --max-count 1 "$string" ./recovery.json)"
build_num="$(echo "$info_string" | grep --max-count 1 -o '"version":.*' | sed 's/^[[:blank:]]*//' | cut -d " " -f 2- | tr -d '",')"
build_url="$(echo "$string" | sed 's/^[[:blank:]]*//' | cut -d " " -f 2- | tr -d '",')"
chrome_version=$(echo $info_string | cut -d "." -f 9 | cut -d '"' -f 7)
brunch_download=$(curl https://api.github.com/repos/sebanc/brunch/releases | grep browser_download_url | grep $chrome_version | tail -n1 |  cut -f
 3 | sed 's/        "browser_download_url"://' | sed 's/"//' | sed "s/\n//")

curl $brunch_download -o brunch.tar.gz
curl $build_url -o update.zip
binfiles=(*.bin)
update="${binfiles[0]}"
sudo chromeos-update -r $update -f brunch.tar.gz

cd ..
echo "Brunch update script done."
