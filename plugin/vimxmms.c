/* -*- C -*-

 * FILE: "/home/life/.vim/plugin/vimxmms.c"
 * LAST MODIFICATION: "Mon, 09 Apr 2001 23:38:45 +0200 (life)"

 * (C) 2001 by Danie Roux <droux@tuks.co.za>
 *
 * Little library to make it possible to control xmms from Vim.
 *
 * You need the xmms development libraries to compile it.
 *
 * Compile it like this:
 *
 * gcc -shared -fPIC `glib-config --cflags` `glib-config --libs` \
 *     -I/usr/include -lxmms -o vimxmms.so vimxmms.c
 *
 * Copy vim_xmms.so to your ~/.vim/plugin directory, get my vimxmms.vim
 * script and you control xmms from vim.
 *
 * This file is placed under the GPL.
 */

#include <xmms/xmmsctrl.h>

void
vim_xmms_forward (int secs)
{
	xmms_remote_jump_to_time (0, xmms_remote_get_output_time (0) +(secs*1000));
}

void
vim_xmms_back (int secs)
{
	xmms_remote_jump_to_time (0, xmms_remote_get_output_time (0) -(secs*1000));
}

/* percentage_points is the number by which the volume has to be increased
 */
int
vim_xmms_volume_up (int percentage_points)
{
	int v;

	v = xmms_remote_get_main_volume (0);

	xmms_remote_set_main_volume (0, v +percentage_points);

	/* Reason I don't ask xmms for it's current volume, is because we get
	 * a race condition again */
	if (v+percentage_points < 0) return 0;
	if (v+percentage_points > 100) return 100;

	return v+percentage_points;
}

int
vim_xmms_volume_down (int percentage_points)
{
	return vim_xmms_volume_up (-percentage_points);
}

char*
__get_playing_song (int orig_pos)
{
	int pos;
	char *new_song;

	if (!xmms_remote_is_running (0))
		return NULL;

	pos = orig_pos;

	/* Wait for xmms to catch up, and start the song. */
	while (pos == orig_pos) pos = xmms_remote_get_playlist_pos (0);

	/* Sometimes, it takes xmms a while to set the title it returns, after
	 * a new position in the playlist is playing. Loop till we have
	 * something. */
	while (!(new_song = xmms_remote_get_playlist_title (0, pos)));

	return new_song;
}

char*
vim_xmms_next_song (int must_have_for_vim)
{
	int orig_pos = xmms_remote_get_playlist_pos (0);

	xmms_remote_playlist_next (0);

	return __get_playing_song (orig_pos);
}

char*
vim_xmms_prev_song (int must_have_for_vim)
{
	int orig_pos = xmms_remote_get_playlist_pos (0);

	xmms_remote_playlist_prev (0);

	return __get_playing_song (orig_pos);
}

char*
vim_xmms_currently_playing (int must_have_for_vim)
{
	/* No orig_pos */
	return __get_playing_song (-1);
}

/* The next two functions let's you return back to an exact position in the
 * song. Great if you want to write down the lyrics or something.
 */
int
vim_xmms_get_time (int must_have_for_vim)
{
	xmms_remote_get_output_time (0);
}

void
vim_xmms_set_time (int time)
{
	xmms_remote_jump_to_time (0, time);
}
