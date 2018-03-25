#!/usr/bin/env python3
'''
copy-to-sd.py
Kevin Murphy 3/19/2018

This program exists to keep track of the artists copied from my main music
directory to the SD Card for my phone.  Obviously, it's extendable to other
scenarios simply by changing SOURCE_DIR and TARGET_DIR.
'''

import eyed3 # sudo -H pip2 install eyeD3
import json
import logging
import os
import pygn  # curl https://raw.githubusercontent.com/cweichen/pygn/master/pygn.py > pygn.py
import requests
import shutil

ARTISTS = 'artists.txt'
ALBUM_ART_FILE_NAME = 'front.jpeg'
CLIENT_ID = '2016435791-02CA61403E3EB62723584D41E59C8455' # gracenote API
SOURCE_DIR = "/Volumes/ /music/iTunes/iTunes Music/Music"

def check_metadata( user_id, path, errors=[], fix_errors=False ):
    for root, dirs, files in os.walk(path):

        save_changes = True

        if dirs == []: # album
            artist = os.path.basename(os.path.dirname(root))
            album  = os.path.basename(root)
            album_path = os.path.join( path, album )
            print (' - %s' % album )

            data = pygn.search( clientID=CLIENT_ID, userID=user_id, artist=artist, album=album )
            #print( json.dumps(data, indent=3 ))

            if check_errors( data, artist, album ):
                if fix_errors:
                    resolve_errors( data, artist, album )
                else:
                    print( ' ->ERROR' )
                    errors.append( path )
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

    res = requests.get( url, stream=True )
    if res.status_code == 200:
        res.raw.decode_content = True
        album_art_path = os.path.join( album_path, ALBUM_ART_FILE_NAME )
        with open( album_art_path, 'wb' ) as f:
            shutil.copyfileobj( res.raw, f )

    else:
        print( 'ERROR: Unable to download album art' )

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
    album_art_data = open( album_art_path, 'rb' ).read()
    file_data.images.set(3, album_art_data, 'image/jpeg')

    try:
        file_data.save()
    except eyed3.id3.tag.TagException:
        file_data.save(version=(2,3,0))

def get_genre( data ):
    genre = ''
    for genre_item in data['genre']:
        genre += data['genre'][genre_item]['TEXT'] + '; '
    return genre[:-2]

def check_errors( data, artist, album ):
    return data['album_artist_name'].lower() != artist.lower() or data['album_title'].lower() != album.lower()

def resolve_errors( data, artist, album ):
    if data['album_artist_name'].lower() != artist.lower():
        if resolve_error( data, 'ARTIST' ) == None:
            return None
    if data['album_title'].lower() != album.lower():
        if resolve_error( data, 'ALBUM' ) == None:
            return None
    return True

def resolve_error( data, field ):
    data_field = 'album_artist_name' if field=='ARTIST' else 'album_title'
    res = input( 'change %s (to `%s`)? ' % (field, data[data_field]) )

    if res == '':
        print( 'changed %s to `%s`' % (field, data[data_field]) )
        return True
    elif res == '/':
        print( 'skipping...' )
        return None
    else:
        print( 'changed %s to `%s`' % (field, res) )
        data[data_field] = res
        return True

def validate_path(path, require_valid=False):
    if os.path.exists( path ):
        return path
    print( 'unable to resolve path: %s' % path )
    if require_valid:
        exit(1)

def main():

    eyed3.log.setLevel(logging.ERROR)
    user_id = pygn.register( CLIENT_ID )
    src = validate_path( SOURCE_DIR, require_valid=True )

    errors = []

    with open( ARTISTS ) as f:
        for artist in f.readlines():
            artist = artist.strip()

            if artist == 'Alvvays':
                break
            artist_src_dir = validate_path( os.path.join( src, artist ) )
            check_metadata( user_id, artist_src_dir, errors=errors, fix_errors=False )

    print( '\n-----------\nRESOLVE ERRORS: enter `/` to skip, `` to accept changes, or new value'  )
    for err_path in errors:
        check_metadata( user_id, err_path, errors=[], fix_errors=True )

main()
