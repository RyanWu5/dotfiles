# Set 256 bit color
if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
	export TERM=xterm-256color
fi

# Add ycm-generator to PATH
export PATH=$PATH:$HOME/.vim/bundle/ycm-generator/
