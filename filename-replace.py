"""
Kevin Murphy
1/18/2018

rename-files.py
Takes a text file mapping a series of filename replacements delimited by MAJ_DELIM (default=\n)
and MIN_DELIM (default=\t) and copies name-replaced files to an output directory
"""

import argparse, os, shutil, sys

def isMatch( lookfor, lookin, rules ):

    if lookin in { '.DS_Store' }:
        return False

    if rules.exact == True: # require exact match
        return lookfor == lookin

    return lookfor in lookin

def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('map', help='mapping file (note: rewrites THIS order)')
    parser.add_argument('-x', default=False, help='add this flag to perform the copy', action="store_true")
    parser.add_argument('-p','--path', default='.', help='path to files that need replacing (default `pwd`)')
    parser.add_argument('-o', '--out', default='out', help='directory name to write files to')
    parser.add_argument('-D','--maj-delim', default='\n', help='delimiter between different map-items (default `newline`)')
    parser.add_argument('-d','--min-delim', default='\t', help='delimiter between source-target w/in map-items (default `tab`)')
    parser.add_argument('-s','--strip', default=None, help='strip particular characters off map-sub-items')
    parser.add_argument('-um', default=False, help='when set, outputs unused map-items', action='store_true')
    parser.add_argument('-uf', default=False, help='when set, outputs untouched files', action='store_true')
    parser.add_argument('-q', '--quiet', default=False, help='set this flag to suppress filename->filename printouts', action='store_true')
    parser.add_argument('-e', '--exact', default=False, help='set this flag to require exact matches', action='store_true')
    args = parser.parse_args()

    # make sure this path exists
    if os.path.exists( args.path ) == False:
        print ('path does not exist (%s)' % args.path)
        exit(1)
    # and the mapping exists
    if os.path.exists( args.map ) == False:
        print ('map does not exist (%s)' % args.map)
        exit(1)

    outdir = os.path.join( args.path, args.out )
    if os.path.exists( outdir ) == False and args.x:
        os.mkdir( outdir )

    # read in the mapping
    with open( args.map, 'r' ) as f:
        lines = f.read()

    # separate out into orig and dest strings
    unusedSwaps = {}
    untouchedFiles = set( os.listdir( args.path ) )
    print( 'REPLACING ITEMS' )
    for line in lines.split( args.maj_delim ):
        if args.min_delim not in line:
            print( 'unable to parse map-item: (%s)' % line )
            continue

        orig, dest = line.split( args.min_delim )
        if args.strip != None:
            orig = orig.strip( '%s' % args.strip )
            dest = dest.strip( '%s' % args.strip )

        if len(orig) == 0:
            print ( 'unable to parse empty map-item: (%s)' % line )
            continue

        swapped = False
        for f in os.listdir( args.path ):
            filename = os.path.basename(f)
            if isMatch( orig, filename, args ):
                if f in untouchedFiles:
                    untouchedFiles.remove(f)
                oldpath = os.path.join( args.path, filename )
                newname = filename.replace( orig, dest )
                newpath = os.path.join( outdir, newname )
                swapped = True
                if args.quiet == False:
                    print( 'cp %s\n > %s' % ( oldpath, newpath) )
                if args.x == True:
                    shutil.copy2( oldpath, newpath )

        if swapped == False:
            unusedSwaps[ orig ] = dest

    if args.uf:
        print( 'WARNING: did not moves these files:' )
        for f in untouchedFiles:
            print( ' * %s' % f )
    if args.um:
        print( 'WARNING: did not find these items:' )
        for us in unusedSwaps:
            print( ' * %-50s -> [%s]' % ( '['+us+']', unusedSwaps[us]) )

    exit()


if __name__ == "__main__":
    main()
