" -*- vim -*-

" FILE: "/home/life/.vim/plugin/vimxmms.vim"
" LAST MODIFICATION: "Tue, 10 Apr 2001 01:57:44 +0200 (life)"

" (C) 2001 by Danie Roux <droux@tuks.co.za> 
" 
" This is a Vim script, that together with vimxmms.so, allows you to control
" XMMS from Vim. You should get that the same place you got this script, else
" mail me. Also see the documentation in vimxmms.txt.

if exists ("loaded_vimxmms")
	finish
endif
let loaded_vimxmms = 1

if !exists ("g:Vimxmms_libxmms")
	let g:Vimxmms_libxmms = "/usr/lib/libxmms.so"
endif

function! VimxmmsToggleShuffle()
	if libcallnr (g:Vimxmms_libxmms, "xmms_remote_is_running", 0) == 0
		return "XMMS is not running"
	endif
	" First check the toggle, or we get a race condition.
	let was_toggled = libcallnr (g:Vimxmms_libxmms, "xmms_remote_is_shuffle", 0)
	call libcallnr (g:Vimxmms_libxmms, "xmms_remote_toggle_shuffle", 0)
	if (was_toggled == 0)
		return 'XMMS Playlist Shuffled'
	else
		return 'XMMS Playlist In order'
	endif
endfunction

function! VimxmmsTogglePause()
	if libcallnr (g:Vimxmms_libxmms, "xmms_remote_is_running", 0) == 0
		return "XMMS is not running"
	endif
	" First make sure that a file is playing, be it paused or not.
	if libcallnr (g:Vimxmms_libxmms, "xmms_remote_is_playing", 0)
		" First check the toggle, or we get a race condition.
		let was_paused = libcallnr (g:Vimxmms_libxmms, "xmms_remote_is_paused", 0)
		call libcallnr (g:Vimxmms_libxmms, "xmms_remote_pause", 0)
		if (was_paused == 0)
			return 'XMMS paused'
		else
			return 'XMMS playing'
		endif
	else
		" Nothing is playing.
		call libcallnr (g:Vimxmms_libxmms, "xmms_remote_play", 0)
		return 'XMMS playing'
	endif
endfunction

function! VimxmmsNextSong()
	if libcallnr (g:Vimxmms_libxmms, "xmms_remote_is_running", 0) == 0
		return "XMMS is not running"
	endif
	return libcall(g:Vimxmms_lib, "vim_xmms_next_song", 0)
endfunction

function! VimxmmsPrevSong()
	if libcallnr (g:Vimxmms_libxmms, "xmms_remote_is_running", 0) == 0
		return "XMMS is not running"
	endif
	return libcall(g:Vimxmms_lib, "vim_xmms_prev_song", 0)
endfunction

function! VimxmmsQuickPrevSong()
	call libcallnr(g:Vimxmms_libxmms, "xmms_remote_playlist_prev", 0)
endfunction

function! VimxmmsQuickNextSong()
	call libcallnr(g:Vimxmms_libxmms, "xmms_remote_playlist_next", 0)
endfunction

function! VimxmmsCurrentlyPlaying()
	if libcallnr (g:Vimxmms_libxmms, "xmms_remote_is_running", 0) == 0
		return "XMMS is not running"
	endif
	return libcall(g:Vimxmms_lib, "vim_xmms_currently_playing", 0)
endfunction

function! VimxmmsForward(seconds)
	call libcallnr(g:Vimxmms_lib, "vim_xmms_forward", a:seconds)
endfunction

function! VimxmmsBack(seconds)
	call libcallnr(g:Vimxmms_lib, "vim_xmms_back", a:seconds)
endfunction

function! VimxmmsVolumeUp(percentage_points)
	return libcallnr(g:Vimxmms_lib, "vim_xmms_volume_up", a:percentage_points)
endfunction

function! VimxmmsVolumeDown(percentage_points)
	return libcallnr(g:Vimxmms_lib, "vim_xmms_volume_down", a:percentage_points)
endfunction

function! VimxmmsGetTime()
	return libcallnr(g:Vimxmms_lib, "vim_xmms_get_time", 0)
endfunction

function! VimxmmsSetTime(time)
	call libcallnr(g:Vimxmms_lib, "vim_xmms_set_time", a:time)
endfunction

function! VimxmmsQuit()
	call libcallnr(g:Vimxmms_libxmms, "xmms_remote_quit", 0)
endfunction

" For this to work, you need to tell xmms, under the libmpg123 plugin options,
" to output in the format: %8/%7.%9
function! VimxmmsDeletePlaying()
	let doomed = VimxmmsCurrentlyPlaying ()
	if input("You sure you want to delete ".doomed."? ") == "y"
		call delete (doomed)
	endif
endfunction

