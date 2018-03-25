#!/usr/bin/env python3
'''
copy-to-sd.py
Kevin Murphy 3/25/2018

This program exists to keep track of the artists copied from my main music
directory to the SD Card for my phone.  Obviously, it's extendable to other
scenarios simply by changing SOURCE_DIR and TARGET_DIR.
'''

import argparse, os, sys
from distutils import dir_util

def validate_path(path, require_valid=False):
    if os.path.exists( path ):
        return path
    print( 'unable to resolve path: %s' % path )
    if require_valid:
        exit(1)

def main():

    parser = argparse.ArgumentParser()
    parser.add_argument( '-a', '--artists', default='artists.txt', help='newline-separated line of artists to be evaluated (default=`artists.txt`)' )
    parser.add_argument( '-o', '--overwrite', action='store_true', help='overwrite existing data if found' )
    parser.add_argument( '-s', '--source', default='/Volumes/ /music/iTunes/iTunes Music/Music', help='path to music library' )
    parser.add_argument( '-t', '--target', default='/Volumes/BLU/Music', help='path to remote library' )
    args = parser.parse_args()

    src = validate_path( args.source, require_valid=True )
    tar = validate_path( args.target, require_valid=True )

    with open( args.artists ) as f:
        for artist in f.readlines():
            artist = artist.strip()

            artist_src_dir = validate_path( os.path.join( src, artist ) )
            artist_tar_dir = os.path.join( tar, artist )

            if os.path.exists( artist_tar_dir ) and args.overwrite==False:
                print( ' > skipping %s (already copied)' % artist )
            else:
                print( 'copying %s' % artist )
                dir_util.copy_tree( artist_src_dir, artist_tar_dir )

main()
