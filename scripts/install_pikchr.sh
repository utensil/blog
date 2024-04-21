SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT="$SCRIPT_DIR/.."
PIKCHR_ROOT="$PROJECT_ROOT/../pikchr-cmd"
PIKCHR_BIN="$PIKCHR_ROOT/pikchr"

cd $PROJECT_ROOT

# Test the following with `rm ../pikchr-cmd/pikchr`

if [ ! -e $PIKCHR_BIN ]; then
    echo "Installing pikchr"
    (git clone https://github.com/zenomt/pikchr-cmd $PIKCHR_ROOT) || (cd $PIKCHR_ROOT && git pull)
    cd $PIKCHR_ROOT
    make all
fi

cd $PROJECT_ROOT

if [ ! -e $PIKCHR_BIN ]; then
    echo "Error: pikchr binary not found and failed to install"
    exit 1
fi
