function less() {
	if [[ $# = 0 ]] ; then
	  vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' -
	else
	  vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' "$@"
	fi
}
