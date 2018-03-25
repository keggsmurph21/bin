#!/usr/bin/env python3
'''
validate-id3v2.py
Kevin Murphy 3/25/2018

This program updates some id3v2 metadata fields for a given list of artists in
a specified directory.
'''

import argparse
import eyed3 # sudo -H pip3 install eyeD3
import json
import logging
import os
import pygn  # curl https://raw.githubusercontent.com/cweichen/pygn/master/pygn.py > pygn.py
import requests
import shutil

ALBUM_ART_FILE_NAME = 'front.jpeg'
ERROR_FILE_PATH = '/tmp/errors.txt'
NO_ALBUM_ART_FILE_PATH = '/tmp/no_album_art.txt'
PERSIST_ERRORS_FILE_PATH = '/tmp/persistent.txt'

logger = None

def check_errors( data, artist, album ):
    got_artist = data['album_artist_name']
    got_album  = data['album_title']

    if artist.lower() != got_artist.lower():
        logger.warning( 'data mismatch\n\texpected `%s`\n\tgot `%s`)' % (artist, got_artist) )
        return True
    if album.lower() != got_album.lower():
        logger.warning( 'data mismatch\n\texpected `%s`\n\tgot `%s`)' % (album, got_album) )
        return True
    return False

def check_metadata( client_id, user_id, path, fix_errors=False ):
    for root, dirs, files in os.walk(path):

        save_changes = True

        if dirs == []: # album
            artist = os.path.basename(os.path.dirname(root))
            album  = os.path.basename(root)
            album_path = path if fix_errors else os.path.join( path, album )
            print( ' - %s' % album  )

            data = pygn.search( clientID=client_id, userID=user_id, artist=artist, album=album )

            logger.debug( json.dumps(data, indent=3 ) )

            if check_errors( data, artist, album ):
                if fix_errors:
                    resolve_errors( data, artist, album )
                    print() # spacing
                else:
                    with open( ERROR_FILE_PATH, 'a' ) as f:
                        f.write( '%s\n' % album_path )
                    save_changes = False

            if save_changes:
                download_album_art( album_path, data['album_art_url'] )
                for f in files:
                    update_metadata( album_path, f, data )

        else: # artist
            artist  = os.path.basename(root)
            print( '\n%s' % artist )

def download_album_art( album_path, url ):
    global ALBUM_ART_FILE_NAME

    if url != '':

        res = requests.get( url, stream=True )
        if res.status_code == 200:
            res.raw.decode_content = True
            album_art_path = os.path.join( album_path, ALBUM_ART_FILE_NAME )
            with open( album_art_path, 'wb' ) as f:
                shutil.copyfileobj( res.raw, f )
            return

    logger.warning( 'unable to download album art' )
    with open( NO_ALBUM_ART_FILE_PATH, 'a' ) as f:
        f.write( '%s\n' % album_path )

def get_genre( data ):
    genre = ''
    for genre_item in data['genre']:
        genre += data['genre'][genre_item]['TEXT'] + '; '
    return genre[:-2]

def resolve_error( data, field ):
    data_field = 'album_artist_name' if field=='ARTIST' else 'album_title'
    res = input( 'change %s (to `%s`)? ' % (field, data[data_field]) )

    if res == '':
        logger.info( 'changed %s to `%s`' % (field, data[data_field]) )
        return True
    elif res == '\\':
        logger.info( 'skipping...' )
        return None
    else:
        logger.info( 'changed %s to `%s`' % (field, res) )
        data[data_field] = res
        return True

def resolve_errors( data, artist, album ):
    if data['album_artist_name'].lower() != artist.lower():
        if resolve_error( data, 'ARTIST' ) == None:
            return None
    if data['album_title'].lower() != album.lower():
        if resolve_error( data, 'ALBUM' ) == None:
            return None
    return True

def set_verbosity( args ):
    global VERBOSITY
    VERBOSITY = 0 if args.quiet else args.verbose

def update_metadata( album_path, file_name, data ):
    global ALBUM_ART_FILE_NAME

    file_path = os.path.join( album_path, file_name )
    file_data = eyed3.load( file_path )
    if file_data == None: # whatever eyed3 can't load
        return

    file_data = file_data.tag

    file_data.artist        = data['album_artist_name']
    file_data.album_artist  = data['album_artist_name']
    file_data.album         = data['album_title']

    year = data['album_year']
    if len(year):
        file_data.original_release_date = year

    file_data.genre = get_genre(data)

    album_art_path = os.path.join( album_path, ALBUM_ART_FILE_NAME )
    if os.path.exists( album_art_path ):
        album_art_data = open( album_art_path, 'rb' ).read()
        file_data.images.set(3, album_art_data, 'image/jpeg')

    try:
        file_data.save()
    except (eyed3.id3.tag.TagException, NotImplementedError):
        file_data.save(version=(2,3,0))

def validate_path(path, require_valid=False):
    if os.path.exists( path ):
        return path
    logger.error( 'unable to resolve path: %s' % path )
    if require_valid:
        exit(1)

def main():
    global logger

    parser = argparse.ArgumentParser()
    parser.add_argument( '-a', '--artists', default='artists.txt', help='newline-separated line of artists to be evaluated (default=`artists.txt`)' )
    parser.add_argument( '-e', '--errors', action='store_true', help='run only on directories saved to the error file' )
    parser.add_argument( '-E', '--end', default='', help='run only for artists alphabetically at or before this value' )
    parser.add_argument( '-g', '--gnid', default='2016435791-02CA61403E3EB62723584D41E59C8455', help='gracenote client id' )
    parser.add_argument( '-q', '--quiet', action='store_true' )
    parser.add_argument( '-R', '--only-missing-artwork', action='store_true', help='run only for albums in the no-album-art file' )
    parser.add_argument( '-s', '--source', default='/Volumes/ /music/iTunes/iTunes Music/Music', help='path to music library' )
    parser.add_argument( '-S', '--start', default='', help='run only for artists alphabetically at or after this value')
    parser.add_argument( '-v', '--verbose', action='count', default=2 )
    args = parser.parse_args()

    level = 50 if args.quiet else max(5-args.verbose,1)*10
    logger = logging.getLogger(__name__)
    logger.setLevel( level )

    eyed3.log.setLevel(logging.ERROR)
    user_id = pygn.register( args.gnid )
    src = validate_path( args.source, require_valid=True )

    if args.only_missing_artwork:
        with open( NO_ALBUM_ART_FILE_PATH ) as f:
            paths = [line.strip() for line in f.readlines()]
            for path in paths:
                album_art_path = os.path.join( path, ALBUM_ART_FILE_NAME )
                if os.path.exists( album_art_path ):
                    album_art_data = open( album_art_path, 'rb' ).read()
                    for root, dirs, files in os.walk(path):
                        for f in files:
                            file_path = os.path.join(path,f)
                            file_data = eyed3.load( file_path )
                            if file_data != None: # whatever eyed3 can't load
                                file_data.tag.images.set(3, album_art_data, 'image/jpeg')
                                file_data.tag.save()
                            else:
                                logger.warning( 'couldn\'t save to file `%s`' % file_path )
                else:
                    logger.warning( 'unable to find album art `%s`' % album_art_path )
        exit()

    if args.errors == False:
        with open( args.artists ) as f:
            for artist in f.readlines():

                if artist >= args.start and (artist <= args.end or args.end == ''):
                    artist_src_dir = validate_path( os.path.join( src, artist.strip() ) )
                    check_metadata( args.gnid, user_id, artist_src_dir, fix_errors=False )

    if os.path.exists( ERROR_FILE_PATH ):
        with open( ERROR_FILE_PATH ) as f:
            errors = [line.strip() for line in f.readlines()]
            if len(errors):
                print( '\n-----------\nRESOLVE ERRORS: enter `\\` to skip, `` to accept changes, or new value\n' )
            for err_path in errors:
                check_metadata( args.gnid, user_id, err_path, fix_errors=True )

main()
