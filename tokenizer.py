#!/usr/bin/env python3
# -*- encoding:utf-8 -*-
'''
Kevin Murphy
March 26, 2018

Takes an input file with sentences delimited by newlines and converts it into
a basic CoNLLU format (no tags or dependencies specified).
'''

import argparse, os, re

def tokenize( infile, outfile='out.conllu' ):

    # make sure it exists
    if os.path.exists( infile ) == False:
        print( 'ERROR: unable to locate file `%s`' % infile )
        exit(1)

    # open infile & outfile
    with open( infile, 'r' ) as f_in, open( outfile, 'w' ) as f_out:

        # doc metadata
        f_out.write( '# newdoc id = km_tokenizer_doc_%s\n' % infile )

        # for each sentence
        lines = [ line.strip() for line in f_in.readlines() ]
        for li, line in enumerate(lines):

            # write the sentence-level metadata
            f_out.write( '# sentence_id = km_tokenizer_doc_%s_sentence_%d\n' %
                (infile, li+1) )
            f_out.write( '# text = %s\n' % line )

            # separate out punctuation
            line = re.sub( r'([.,;“”"()])', r' \1 ', line )
            # delete redundant spaces
            line = re.sub( r'[ ]+', r' ', line )

            # split into lemmas
            lemmas = [lemma for lemma in line.split(' ') if len(lemma)]

            # conllu dependency skeleton
            skeleton = '\t'.join(['_' for i in range(8)])

            # write lemmas
            for le, lemma in enumerate(lemmas):
                f_out.write( '%d\t%s\t%s\n' % (le+1, lemma, skeleton) )

            f_out.write( '\n' )

def main():

    # get input file
    parser = argparse.ArgumentParser()
    parser.add_argument( 'input' )
    args = parser.parse_args()

    # do the work
    tokenize( infile=args.input )

if __name__ == '__main__':
    main()
