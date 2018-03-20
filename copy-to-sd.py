#!/usr/bin/python
'''
copy-to-sd.py
Kevin Murphy 3/19/2018

This program exists to keep track of the artists copied from my main music
directory to the SD Card for my phone.  Obviously, it's extendable to other
scenarios simply by changing SOURCE_DIR and TARGET_DIR.
'''

import os
from distutils import dir_util

SOURCE_DIR = "/Volumes/ /Music/iTunes/iTunes Music/Music"
TARGET_DIR = "/Volumes/BLU/Music"
ARTISTS = [
    '12 Rods',
    'Alvvays',
    'American Football',
    'Animal Collective',
    'Aphex Twin',
    'Archers of Loaf',
    'Avey Tare',
    'Avey Tare & Panda Bear',
    'Bass Drum of Death',
    'Beirut',
    'Belle & Sebastian',
    'Big L',
    'Bill Callahan',
    'Björk',
    'Black Star',
    'Boards of Canada',
    'Bonnie \'Prince\' Billy',
    'Boris',
    'Brand New',
    'Broken Social Scene',
    'Built to Spill',
    'Burial',
    'Can',
    'Cap_n Jazz',
    'Car Seat Headrest',
    'Charles Mingus',
    'Cloud Nothings',
    'Cocteau Twins',
    'CunninLynguists',
    'DJ Shadow',
    'Das Racist',
    'Dave Matthews',
    'Dave Matthews Band',
    'Deerhunter',
    'Dinosaur Jr_',
    'Elliott Smith',
    'Erykah Badu',
    'Fela Kuti',
    'Fishmans',
    'Fleet Foxes',
    'Fleetwood Mac',
    'Frank Ocean',
    'Freddie Gibbs & Madlib',
    'Fugazi',
    'GZA',
    'Galaxie 500',
    'Gang of Four',
    'Godspeed You! Black Emperor',
    'Gorillaz',
    'Guided By Voices',
    'Hop Along',
    'Isaiah Rashad',
    'James Blake',
    'Jeff Mangum',
    'Joanna Newsom',
    'John Frusciante',
    'Joni Mitchell',
    'Jordaan Mason and the Horse Museum',
    'Joy Division',
    'Kanye West',
    'Kate Tempest',
    'Kendrick Lamar',
    'Kid Cudi',
    'Kid Dakota',
    'King Crimson',
    'King Krule',
    'LCD Soundsystem',
    'Leonard Cohen',
    'Lil Wayne',
    'Lil\' Wayne',
    'MF DOOM',
    'Macintosh Plus',
    'Madvillain',
    'Massive Attack',
    'Mercury Rev',
    'Miles Davis',
    'Minutemen',
    'Modest Mouse',
    'Moondog',
    'Mos Def',
    'My Bloody Valentine',
    'Nas',
    'Neutral Milk Hotel',
    'Nick Drake',
    'Noname',
    'Nosaj Thing',
    'Nujabes',
    'OutKast',
    'PJ Harvey',
    'Panda Bear',
    'Paul Simon',
    'Pavement',
    'Pink Floyd',
    'Pixies',
    'Portishead',
    'Portugal. The Man',
    'Prefuse 73',
    'Raekwon',
    'Ramones',
    'Red Hot Chili Peppers/Stadium Arcadium', # only this album
    'Rich Gang',
    'RJD2',
    'Röyksopp',
    'STRFKR',
    'Sebadoh',
    'Sex Pistols',
    'Slint',
    'Slowdive',
    'Sonic Youth',
    'Spacemen 3',
    'Spiritualized',
    'Stereolab',
    'Strand of Oaks',
    'Sufjan Stevens',
    'Sun Kil Moon',
    'Sun Ra',
    'Sunny Day Real Estate',
    'Swans',
    'Talk Talk',
    'Talking Heads',
    'Tame Impala',
    'Television',
    'The Antlers',
    'The Clash',
    'The Dismemberment Plan',
    'The Flaming Lips',
    'The Hotelier',
    'The Jesus and Mary Chain',
    'The Mountain Goats',
    'The National',
    'The Olivia Tremor Control',
    'The Ramones',
    'The Roots',
    'The Smiths',
    'The Velvet Underground',
    'The World is a Beautiful Place & I am No Longer Afraid to Die',
    'Tom Waits',
    'Vince Staples',
    'Wavves',
    'Weezer',
    'Wilco',
    'Wire',
    'World\'s End Girlfriend',
    'Wu-Tang Clan',
    'Xenia Rubinos',
    'Xiu Xiu',
    'Yo La Tengo',
    'Young Thug',
    '(Sandy) Alex G'
]

def validate(path, exit=False):
    if os.path.exists( path ):
        return path
    print( 'unable to resolve path: %s' % path )
    if exit:
        exit(1)

def main():
    src = validate( SOURCE_DIR, exit=True )
    tar = validate( TARGET_DIR, exit=True )

    for artist in ARTISTS:

        artist_src_dir = validate( os.path.join( src, artist ) )
        artist_tar_dir = os.path.join( tar, artist )

        if os.path.exists( artist_tar_dir ):
            print( ' > skipping %s (already copied)' % artist )
        else:
            print( 'copying %s' % artist )
            dir_util.copy_tree( artist_src_dir, artist_tar_dir )

main()
