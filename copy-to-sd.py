#!/usr/bin/env python3
'''
copy-to-sd.py
Kevin Murphy 3/25/2018

This program exists to keep track of the artists copied from my main music
directory to the SD Card for my phone.  Obviously, it's extendable to other
scenarios simply by changing SOURCE_DIR and TARGET_DIR.
'''

import os, sys
from distutils import dir_util

ARTISTS = 'artists.txt'
SOURCE_DIR = "/Volumes/ /music/iTunes/iTunes Music/Music"
TARGET_DIR = "/Volumes/BLU/Music"

def validate_path(path, require_valid=False):
    if os.path.exists( path ):
        return path
    print( 'unable to resolve path: %s' % path )
    if require_valid:
        exit(1)

def main():

    overwrite = False
    if len(sys.argv) > 1:
        if sys.argv[1] == '-f':
            overwrite = True

    src = validate_path( SOURCE_DIR, require_valid=True )
    tar = validate_path( TARGET_DIR, require_valid=True )

    with open( ARTISTS ) as f:
        for artist in f.readlines():
            artist = artist.strip()

            artist_src_dir = validate_path( os.path.join( src, artist ) )
            artist_tar_dir = os.path.join( tar, artist )

            if os.path.exists( artist_tar_dir ) and overwrite==False:
                print( ' > skipping %s (already copied)' % artist )
            else:
                print( 'copying %s' % artist )
                dir_util.copy_tree( artist_src_dir, artist_tar_dir )

main()
